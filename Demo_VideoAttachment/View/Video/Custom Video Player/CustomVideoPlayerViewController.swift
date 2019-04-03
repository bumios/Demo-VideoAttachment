//
//  CustomVideoPlayerViewController.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/25/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit
import Photos

final class CustomVideoPlayerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var videoContentView: UIView!
    @IBOutlet weak var fromDurationSeperateView: UIView!
    @IBOutlet weak var toDurationSeperateView: UIView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var splitFromButton: UIButton!
    @IBOutlet weak var splitToButton: UIButton!
    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var fromDurationLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var toDurationLeadingConstraint: NSLayoutConstraint!

    // MARK: - Properties
    let viewModel: CustomVideoPlayerViewModel
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var isPlayingVideo: Bool = false {
        didSet {
            if isPlayingVideo {
                playPauseButton.setTitle("Pause", for: .normal)
            } else {
                playPauseButton.setTitle("Continue", for: .normal)
            }
        }
    }
    var splitFromTime: Float?
    var splitToTime: Float?

    // MARK: - Life cycle
    init(viewModel: CustomVideoPlayerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateView()
    }

    // MARK: - Public
    private func updateView() {
        let options = PHVideoRequestOptions()
        options.version = .original
        guard let photoAsset = viewModel.photoAsset else { return }
//        ///
//        photoAsset.getURL { url in
//            guard let url = url else { return }
//            BumiosVideoManager.cropVideo(sourceURL: url, start: 5, end: 10)
//        }
//        ///
        PHImageManager.default().requestPlayerItem(forVideo: photoAsset, options: options) { [weak self] (video, _) in
            guard let this = self, let video = video else { return }
            this.player = AVPlayer(playerItem: video)
            this.playerLayer = AVPlayerLayer(player: this.player)
            let contentViewFrame = this.videoContentView.frame
            this.playerLayer.frame = contentViewFrame
            // TODO: - Số 30 ở đâu ra zị ta ???
            this.playerLayer.frame.size = CGSize(width: contentViewFrame.size.width.scaling,
                height: contentViewFrame.size.height + 30)
            this.playerLayer.videoGravity = .resizeAspect
            DispatchQueue.main.async {
                this.trackingPlayerProgress()
                /// Add sublayer for main view
                this.videoContentView.layer.addSublayer(this.playerLayer)
            }
        }
        totalTimeLabel.text = getTimeString(from: Float(photoAsset.duration))
    }

    private func trackingPlayerProgress() {
        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 2),
            queue: .main, using: { [weak self] progressTime in
                guard let this = self else { return }
                let playerCurrentTime = CMTimeGetSeconds(progressTime)
                this.currentTimeLabel.text = this.getTimeString(from: Float(playerCurrentTime))
                if let duration = this.player.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    this.progressSlider.setValue(Float(playerCurrentTime / durationSeconds), animated: true)
                    if playerCurrentTime >= durationSeconds {
                        this.player.seek(to: CMTimeMake(value: 0, timescale: 1_000))
                        this.isPlayingVideo = false
                        this.playPauseButton.setTitle("Play", for: .normal)
                    }
                }
            })
    }

    @objc private func playPauseButtonTapped() {
        isPlayingVideo = !isPlayingVideo
        if isPlayingVideo {
            player.play()
        } else {
            player.pause()
        }
    }

    @objc private func progressSliderValueChanged() {
        guard let videoDuration = viewModel.photoAsset?.duration else { return }
        let expectedTimeResult = progressSlider.value * Float(videoDuration)
        let time = CMTimeMake(value: Int64(expectedTimeResult * 1_000), timescale: 1_000)
        player.pause()
        player.seek(to: time)
        isPlayingVideo = false
    }

    @objc private func splitFromButtonTapped() {
        guard let videoDuration = viewModel.photoAsset?.duration else { return }
        fromDurationSeperateView.isHidden = false
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let progressPercent = currentTime / videoDuration
        let frameX = progressSlider.frame.width * CGFloat(progressPercent)
        fromDurationLeadingConstraint.constant = frameX
        splitFromTime = Float(currentTime)
        print("------------------")
        print("current play: \(currentTime)")
        print("total duration: \(videoDuration)")
        print("progress percent: \(progressPercent)")
        print("progress width: \(progressSlider.frame.width)")
        print("position x: \(frameX)")
    }

    @objc private func splitToButtonTapped() {
        guard let videoDuration = viewModel.photoAsset?.duration else { return }
        toDurationSeperateView.isHidden = false
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let progressPercent = currentTime / videoDuration
        let frameX = progressSlider.frame.width * CGFloat(progressPercent)
        toDurationLeadingConstraint.constant = frameX
        splitToTime = Float(currentTime)
    }

    @objc private func splitButtonTapped() {
        guard let photoAsset = viewModel.photoAsset else {
            // TODO: - Show alert
            print("[ERROR] Base video data is undefined.")
            return
        }
        guard let startTime = splitFromTime, let endTime = splitToTime else {
            // TODO: - Show alert
            print("[ERROR] Both split range (from time & to time) must be pick.")
            return
        }
        photoAsset.getURL { [weak self] url in
            guard let this = self, let url = url else {
                // TODO: - Show alert
                print("[ERROR] Can't detect URL of an image.")
                return
            }
            BumiosVideoManager.cropVideo(sourceURL: url, start: Double(startTime), end: Double(endTime))
        }
    }

    private func getTimeString(from value: Float) -> String {
        let secondsString = String(format: "%02d", Int(value.truncatingRemainder(dividingBy: 60)))
        let minutesString = String(format: "%02d", Int(value / 60))
        return minutesString + ":" + secondsString
    }
}

extension CustomVideoPlayerViewController {
    private func configureUI() {
        playPauseButton.setTitle("Play", for: .normal)
        let image = UIImage()
        progressSlider.setThumbImage(image, for: .normal)
        progressSlider.transform = CGAffineTransform.init(scaleX: 1, y: 5) //Scale(CGAffineTransformIdentity, 1.0, 2.0)
        progressSlider.addTarget(self, action: #selector(progressSliderValueChanged), for: .valueChanged)
        progressSlider.backgroundColor = .black
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        splitFromButton.addTarget(self, action: #selector(splitFromButtonTapped), for: .touchUpInside)
        splitToButton.addTarget(self, action: #selector(splitToButtonTapped), for: .touchUpInside)
        splitButton.addTarget(self, action: #selector(splitButtonTapped), for: .touchUpInside)
    }
}
