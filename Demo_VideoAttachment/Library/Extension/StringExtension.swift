//
//  StringExtension.swift
//  ElectricalCalculator
//
//  Created by Duy Tran N. on 3/4/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

extension String {
    var int: Int {
        guard let integer = Int(self) else { return 0 }
        return integer
    }

    var double: Double {
        guard let double = Double(self) else { return 0 }
        return double
    }
}
