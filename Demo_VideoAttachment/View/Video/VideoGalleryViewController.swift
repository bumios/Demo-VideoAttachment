//
//  VideoGalleryViewController.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/25/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

final class VideoGalleryViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Properties
    let viewModel = VideoGalleryViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.fetchVideoFromLibrary()
    }

    // MARK: - Private
    private func configureUI() {
        collectionView.register(nibWithCellClass: VideoCollectionCell.self)
    }
}

// MARK: - Extension UICollectionViewDataSource
extension VideoGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(VideoCollectionCell.self, indexPath: indexPath)
        let cellVM = viewModel.viewModelForCell(at: indexPath)
        cell.updateView(with: cellVM)
        return cell
    }
}

// MARK: - Extension UICollectionViewDelegateFlowLayout
extension VideoGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoPlayerVM = viewModel.viewModelForVideoPlayer(at: indexPath)
        let customVideoPlayerVC = CustomVideoPlayerViewController(viewModel: videoPlayerVM)
        navigationController?.pushViewController(customVideoPlayerVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}
