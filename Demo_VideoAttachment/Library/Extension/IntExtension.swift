//
//  IntExtension.swift
//  ElectricalCalculator
//
//  Created by Duy Tran N. on 2/21/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

extension Int {
    var scaling: CGFloat {
        return CGFloat(self) * CGFloat.ratio
    }
}
