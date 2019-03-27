//
//  DoubleExtension.swift
//  ElectricalCalculator
//
//  Created by Duy Tran N. on 3/7/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import Foundation

extension Double {
    var string: String {
        return String(format: "%.3f", self)
    }

    var noFractionString: String {
        let formater = NumberFormatter()
        formater.maximumFractionDigits = 0
        guard let formatString = formater.string(from: NSNumber(value: self)) else {
            return "--"
        }
        return formatString
    }

    var vndFormat: String {
        let formater = NumberFormatter()
        formater.maximumFractionDigits = 0
        formater.numberStyle = .currency
        formater.currencySymbol = ""
        guard let formatString = formater.string(from: NSNumber(value: self)) else {
            return "--"
        }
        return formatString
    }
}

extension Notification.Name {
    static let pushToAboutApplicationScreen = Notification.Name("com.bumios.pushToAboutApplicationScreen")
    static let pushToAboutAuthorScreen = Notification.Name("com.bumios.pushToAboutAuthorScreen")
}
