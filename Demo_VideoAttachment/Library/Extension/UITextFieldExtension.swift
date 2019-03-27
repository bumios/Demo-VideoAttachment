//
//  UITextFieldExtension.swift
//  ElectricalCalculator
//
//  Created by Duy Tran N. on 3/4/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

extension UITextField {
    var value: String {
        guard let text = self.text else { return "" }
        return text
    }
}
