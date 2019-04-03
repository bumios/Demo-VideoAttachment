//
//  BumiosVideoManager.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/29/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import Foundation
import Photos
import MobileCoreServices

class BumiosVideoManager {
    static func cropVideo(sourceURL: URL, start: Double, end: Double) {
        let manager = FileManager.default
        guard let documentDirectory = try? manager.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {
                                                            return
        }
        let asset = AVAsset(url: sourceURL)
        let fileExtension = sourceURL.pathExtension

        print("Length: \(Float(asset.duration.value) / Float(asset.duration.timescale))")
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try manager.createDirectory(at: outputURL,
                                        withIntermediateDirectories: true,
                                        attributes: nil)
            let fileName = sourceURL.fileName + "-CROPPED." + fileExtension
            outputURL = outputURL.appendingPathComponent(fileName)
        } catch let error {
            print(error)
        }

        // Remove existing file
        try? manager.removeItem(at: outputURL)

        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = outputURL
        guard let avFileType = getAVFileType(from: fileExtension) else {
            // TODO: - Show alert
            print("[ERROR] can't detect file type")
            return
        }
        exportSession.outputFileType = avFileType

        let startTime = CMTime(seconds: start, preferredTimescale: 1_000)
        let endTime = CMTime(seconds: end, preferredTimescale: 1_000)
        let timeRange = CMTimeRange(start: startTime, end: endTime)

        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                // TODO: - Rename album name
                self.saveVideo(atURL: outputURL, toAlbumNamed: "Bumios-Video")
                DispatchQueue.main.async(execute: {
                    // TODO: - Show alert
                    print("Video crop successfully !")
                })
            case .failed:
                // TODO: - Show alert
                print("failed \(exportSession.error?.localizedDescription)")
            case .cancelled:
                // TODO: - Show alert
                print("cancelled \(exportSession.error?.localizedDescription)")
            default: break
            }
        }
    }

    static func saveVideo(atURL url: URL, toAlbumNamed albumName: String) {
        DispatchQueue.global().async {
            if let album = BumiosFileManager.findOrCreateAlbum(named: albumName) {
                var localIdentifier: String? = nil
                PHPhotoLibrary.shared().performChanges({
                    if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url) {
                        let asset = assetChangeRequest.placeholderForCreatedAsset
                        localIdentifier = asset?.localIdentifier
                        let request = PHAssetCollectionChangeRequest(for: album)
                        request?.addAssets([asset!] as NSArray)
                    } else {
                        print("[ERROR] An error occur in asset change request.")
                    }
                }, completionHandler: { (success, error) in
                    if success {
                        print("Save video into gallery successfully !")
                    } else {
                        print("[ERROR] Failed to save video into gallery.")
                        print("Description: ", error?.localizedDescription)
                    }
                })
            }
        }
    }

    static func getAVFileType(from value: String) -> AVFileType? {
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, value as CFString, nil)
        guard let utiRetainedValue = uti?.takeRetainedValue() else {
            print("[ERROR]: unexpected value of utiRetainedValue")
            return nil
        }
        if UTTypeConformsTo(utiRetainedValue, kUTTypeQuickTimeMovie) {
            return AVFileType.mov
        } else if UTTypeConformsTo(utiRetainedValue, kUTTypeMPEG4) {
            return AVFileType.mp4
        } else if UTTypeConformsTo(utiRetainedValue, kUTTypeAppleProtectedMPEG4Video) {
            return AVFileType.m4v
        }
        return nil
    }
}
