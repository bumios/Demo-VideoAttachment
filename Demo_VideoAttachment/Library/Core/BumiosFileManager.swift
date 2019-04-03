//
//  BumiosFileManager.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/29/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import Foundation
import Photos

class BumiosFileManager {
    static func findOrCreateAlbum(named albumName: String) -> PHAssetCollection? {
        if let album = findAlbum(with: albumName) {
            return album
        } else {
            do {
                try PHPhotoLibrary.shared().performChangesAndWait({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                })
            } catch {
                print("[ERROR] occur when create album: ".appending(albumName))
                print("Description: ", error.localizedDescription)
            }
            return findAlbum(with: albumName)
        }
    }

    static func findAlbum(with albumName: String) -> PHAssetCollection? {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", albumName)
        let findAlbumResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        return findAlbumResult.firstObject
    }
}
