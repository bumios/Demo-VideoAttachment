//
//  VideoPlaygroundViewController.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/22/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit
import AVKit

final class VideoPlaygroundViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    @IBOutlet weak var galleryButton: UIButton!

    // MARK: - Properties
    lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.movie"]
        return imagePickerController
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
    }

    // MARK: Private
    @objc private func galleryButtonTapped() {
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
}

// MARK: - Extension UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension VideoPlaygroundViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        imagePickerController.dismiss(animated: true, completion: nil)
        if let videoURL = videoURL {
            presentVideoController(from: videoURL)
        } else {
            fatalError("videoURL is nil")
        }
    }
}

// MARK: - Video Handling
extension VideoPlaygroundViewController {

    /// Play video using AVKit
    ///
    /// - Parameter url: get from local gallery.
    private func presentVideoController(from url: URL) {
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true) { [weak self] in
            guard let this = self else { return }
            this.videoThumbnailImageView.image = this.thumbnailImage(from: url)
            playerVC.player?.play()     // Autoplay
        }
    }

    private func thumbnailImage(from url: URL) -> UIImage {
        var image = UIImage()
        let asset = AVURLAsset(url: url)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let cgImage = try imgGenerator.copyCGImage(at: CMTime(value: 0, timescale: 1),
                                                   actualTime: nil)
            image = UIImage(cgImage: cgImage)
        } catch {
            fatalError("ERROR rồi: \(error.localizedDescription)")
        }
        return image
    }
}
