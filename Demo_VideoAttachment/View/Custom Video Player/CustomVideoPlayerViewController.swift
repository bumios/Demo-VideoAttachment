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
        guard let videoAsset = viewModel.videoAsset else { return }
        PHImageManager.default().requestPlayerItem(forVideo: videoAsset, options: options) { [weak self] (video, _) in
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
        totalTimeLabel.text = getTimeString(from: Float(videoAsset.duration))
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
        guard let videoDuration = viewModel.videoAsset?.duration else { return }
        let expectedTimeResult = progressSlider.value * Float(videoDuration)
        let time = CMTimeMake(value: Int64(expectedTimeResult * 1_000), timescale: 1_000)
        player.pause()
        player.seek(to: time)
        isPlayingVideo = false
    }

    @objc private func splitFromButtonTapped() {
        guard let videoDuration = viewModel.videoAsset?.duration else { return }
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
        guard let videoDuration = viewModel.videoAsset?.duration else { return }
        toDurationSeperateView.isHidden = false
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let progressPercent = currentTime / videoDuration
        let frameX = progressSlider.frame.width * CGFloat(progressPercent)
        toDurationLeadingConstraint.constant = frameX
        splitToTime = Float(currentTime)
    }

    @objc private func splitButtonTapped() {
        guard let videoAsset = viewModel.videoAsset else {
            // TODO: - Show alert
            print("[ERROR] Base video data is undefined.")
            return
        }
        guard let startTime = splitFromTime, let endTime = splitToTime else {
            // TODO: - Show alert
            print("[ERROR] Both split range (from time & to time) must be pick.")
            return
        }
        videoAsset.getURL { [weak self] url in
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


    // TODO: - Not finished yet
    func attachImageToVideo() {
        var path = ""
        if let moviePath = Bundle.main.path(forResource: "sample_movie", ofType: "mp4") {
            path = moviePath
        }
        let fileURL = URL(fileURLWithPath: path)
        let composition = AVMutableComposition()
        var videoAsset = AVURLAsset(url: fileURL, options: nil)

        viewModel.videoAsset?.getURL(completionHandler: { (url) in
            if let url = url {
                videoAsset = AVURLAsset(url: url, options: nil)
            }

            // get video track
            let videoTracks = videoAsset.tracks(withMediaType: AVMediaType.video)
            let videoTrack: AVAssetTrack = videoTracks[0]
            //        let vid_duration = videoTrack.timeRange.duration
            let videoTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration)

            let compositionvideoTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
            do {
                try compositionvideoTrack?.insertTimeRange(videoTimeRange, of: videoTrack, at: CMTime.zero)
            } catch {
                print("[ERROR] Insert time range video track")
                print("Description: ", error.localizedDescription)
            }

            compositionvideoTrack?.preferredTransform = videoTrack.preferredTransform

            // Watermark Effect
            let size = videoTrack.naturalSize

            let imglogo = #imageLiteral(resourceName: "gin")
            let imglayer = CALayer()
            imglayer.contents = imglogo.cgImage
            imglayer.frame = CGRect(x: 5, y: 5, width: 350, height: 350)
            imglayer.opacity = 0.6

            // create text Layer
            let titleLayer = CATextLayer()
            titleLayer.backgroundColor = UIColor.white.cgColor
            titleLayer.string = "Dummy text"
            titleLayer.font = UIFont(name: "Helvetica", size: 28)
            titleLayer.shadowOpacity = 0.5
            titleLayer.alignmentMode = .center
            titleLayer.frame = CGRect(x: 0, y: 50, width: size.width, height: size.height / 6)

            let videolayer = CALayer()
            videolayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            let parentlayer = CALayer()
            parentlayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            parentlayer.addSublayer(videolayer)
            parentlayer.addSublayer(imglayer)
//            parentlayer.addSublayer(titleLayer)

            let layercomposition = AVMutableVideoComposition()
            layercomposition.frameDuration = CMTime(value: 1, timescale: 30)
            layercomposition.renderSize = size
            layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)

            // instruction for watermark
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
            let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0]
            let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
            instruction.layerInstructions = NSArray(object: layerinstruction) as! [AVVideoCompositionLayerInstruction]
            layercomposition.instructions = NSArray(object: instruction) as! [AVVideoCompositionInstructionProtocol]

            //  create new file to receive data
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir: String = dirPaths[0]
            let movieFilePath = docsDir + "-edited.mp4"
            let movieDestinationUrl = URL(fileURLWithPath: movieFilePath)

            // use AVAssetExportSession to export video
            guard let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else { return }
            assetExport.videoComposition = layercomposition
            assetExport.outputFileType = AVFileType.mp4
            assetExport.outputURL = movieDestinationUrl
            assetExport.exportAsynchronously(completionHandler: {
                switch assetExport.status {
                case .unknown:
                    print("-----------")
                    print("Unknown status")
                case .waiting:
                    print("waiting")
                    print("progress: \(assetExport.progress)")
                case .exporting:
                    print("exporting")
                    print("progress: \(assetExport.progress)")
                case .completed:
                    print("-----------")
                    print("completed")
                case .failed:
                    print("-----------")
                    print("failed")
                case .cancelled:
                    print("-----------")
                    print("cancelled")
                }
            })
        })
    }
}
