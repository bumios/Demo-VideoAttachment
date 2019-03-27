//
//  VideoGalleryViewModel.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/25/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import Foundation
import Photos

final class VideoGalleryViewModel {

    // MARK: - Properties
    var photos: PHFetchResult<PHAsset>? = nil

    // MARK: - Public
    func fetchVideoFromLibrary() {
        if !PermissionManager.shared.isAuthorized {
            PhotoLibraryManager.requestAuthorization()
        } else {
            let fetchOptions = PHFetchOptions()
            photos = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        }
    }

    func numberOfItems(in section: Int) -> Int {
        guard let photos = photos else { return 0 }
        return photos.count
    }

    func viewModelForCell(at indexPath: IndexPath) -> VideoCollectionCellViewModel {
        return VideoCollectionCellViewModel(photoAsset: photos?.object(at: indexPath.row))
    }

    func viewModelForVideoPlayer(at indexPath: IndexPath) -> CustomVideoPlayerViewModel {
        return CustomVideoPlayerViewModel(photoAsset: photos?.object(at: indexPath.row))
    }
}
