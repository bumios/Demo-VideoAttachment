//
//  URLExtension.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 4/1/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import Foundation

extension URL {
    var fileName: String {
        let fullName = self.absoluteString.split(separator: "/").last
        if let fullName = fullName, let name = fullName.split(separator: ".").first {
            return "\(name)"
        }
        return ""
    }
}
