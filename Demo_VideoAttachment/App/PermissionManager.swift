//
//  PermissionManager.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/25/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import Foundation
import Photos

final class PermissionManager {
    static let shared = PermissionManager()

    var isAuthorized: Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
}
