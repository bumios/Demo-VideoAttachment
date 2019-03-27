//
//  VideoCollectionCell.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/25/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit
import Photos

final class VideoCollectionCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var thumbnailImageView: UIImageView!

    // MARK: - Public
    func updateView(with viewModel: VideoCollectionCellViewModel) {
        guard let photoAsset = viewModel.photoAsset else { return }
        let options = PHVideoRequestOptions()
        options.version = .original
        PHImageManager.default().requestPlayerItem(forVideo: photoAsset, options: options) { [weak self] (video, _) in
            guard let this = self, let video = video else { return }
            let player = AVPlayer(playerItem: video)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = this.thumbnailImageView.bounds
            playerLayer.videoGravity = .resizeAspect
            /// Add sublayer for main view
            DispatchQueue.main.async {
                this.thumbnailImageView.layer.addSublayer(playerLayer)
            }
        }
    }
}
