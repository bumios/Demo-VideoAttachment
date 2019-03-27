//
//  CGFloatExtension.swift
//  ElectricalCalculator
//
//  Created by Duy Tran N. on 2/21/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

extension CGFloat {
    static let ratio = UIScreen.main.bounds.width / 375

    var scaling: CGFloat {
        return self * CGFloat.ratio
    }

    var int: Int {
        return Int(self)
    }

    func centerValue(parent: CGFloat, child: CGFloat) -> CGFloat {
        return (parent / 2) - (child / 2)
    }
}
