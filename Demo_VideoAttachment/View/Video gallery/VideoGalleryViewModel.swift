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
    var videos: PHFetchResult<PHAsset>? = nil

    // MARK: - Public
    func fetchVideoFromLibrary() {
        if !PermissionManager.shared.isAuthorized {
            PhotoLibraryManager.requestAuthorization()
        } else {
            let fetchOptions = PHFetchOptions()
            videos = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        }
    }

    func numberOfItems(in section: Int) -> Int {
        guard let videos = videos else { return 0 }
        return videos.count
    }

    func viewModelForCell(at indexPath: IndexPath) -> VideoCollectionCellViewModel {
        return VideoCollectionCellViewModel(videoAsset: videos?.object(at: indexPath.row))
    }

    func viewModelForVideoPlayer(at indexPath: IndexPath) -> CustomVideoPlayerViewModel {
        return CustomVideoPlayerViewModel(videoAsset: videos?.object(at: indexPath.row))
    }
}
