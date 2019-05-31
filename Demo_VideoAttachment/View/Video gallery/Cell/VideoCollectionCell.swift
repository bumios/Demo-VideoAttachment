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
        guard let videoAsset = viewModel.videoAsset else { return }
        videoAsset.getURL { [weak self] url in
            guard let this = self, let url = url else { return }
            let avAsset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: avAsset)
            do {
                let cgImage = try imageGenerator.copyCGImage(at: CMTime(value: 1, timescale: 60), actualTime: nil)
                DispatchQueue.main.async {
                    this.thumbnailImageView.image = UIImage(cgImage: cgImage)
                }
            } catch {
                print("[ERROR] Generator thumbnail image")
                print("Description: ", error.localizedDescription)
            }
        }
    }
}
