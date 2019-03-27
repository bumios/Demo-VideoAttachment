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
    @IBOutlet weak var currentTimeLabel: UILabel!       // NOT USE YET
    @IBOutlet weak var totalTimeLabel: UILabel!         // NOT USE YET
    @IBOutlet weak var progressSlider: UISlider!        // NOT USE YET
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!

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
    }

    private func trackingPlayerProgress() {
        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 2),
                                       queue: .main, using: { [weak self] progressTime in
            guard let this = self else { return }
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minutesString = String(format: "%02d", Int(seconds / 60))
            this.currentTimeLabel.text = "\(minutesString):\(secondsString)"
            //lets move the slider thumb
            if let duration = this.player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                this.progressSlider.setValue(Float(seconds / durationSeconds), animated: true)
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

    @objc private func backwardButtonTapped() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime - 1
        let time = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        player.seek(to: time)
    }

    @objc private func forwardButtonTapped() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 1
        let time = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        player.seek(to: time)
    }

    @objc private func doneButtonTapped() {
    }
}

extension CustomVideoPlayerViewController {
    private func configureUI() {
        let myImage = UIImage()
        progressSlider.setThumbImage(myImage, for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        backwardButton.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
}
