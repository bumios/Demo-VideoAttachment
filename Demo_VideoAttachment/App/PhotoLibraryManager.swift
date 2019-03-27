//
//  PhotoLibraryManager.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/25/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import Foundation
import Photos

final class PhotoLibraryManager {
    static func requestAuthorization() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined: // User has not yet made a choice with regards to this application
            print("[Permission - Photo Library]: not determined.")
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("[Permission - Photo Library] User `APPROVED` permission.")
                default:
                    print("[Permission - Photo Library] User `DENIED` permission.")
                }
            }
        case .restricted: // This application is not authorized to access photo data.
            print("[Permission - Photo Library]: restricted.")
        case .denied: // User has explicitly denied this application access to photos data.
            print("[Permission - Photo Library]: denied.")
        case .authorized: // User has authorized this application to access photos data.
            print("[Permission - Photo Library]: authorized.")
        }
    }
}
