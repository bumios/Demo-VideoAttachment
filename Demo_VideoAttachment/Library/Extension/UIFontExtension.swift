//
//  UIFontExtension.swift
//  ElectricalCalculator
//
//  Created by Duy Tran N. on 2/25/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

extension UIFont {
    enum Roboto: String {
        case robotoBlack, robotoBlackItalic, robotoBold, robotoBoldItalic, robotoItalic, robotoLight, robotoLightItalic, robotoMedium, robotoMediumItalic, robotoRegular, robotoThin, robotoThinItalic

        var name: String {
            var outputFontName = ""
            var isAbleReplace: Bool = true
            for (index, character) in self.rawValue.enumerated() {
                if index == 0 {
                    outputFontName += String(character).uppercased()
                } else {
                    if String(character) == String(character).uppercased() && isAbleReplace {
                        isAbleReplace = !isAbleReplace
                        outputFontName += "-\(String(character))"
                    } else {
                        outputFontName += String(character)
                    }
                }
            }
            return outputFontName
        }
    }

    func load(font: Roboto, fontSize: CGFloat = 13) -> UIFont {
        guard let customFont = UIFont(name: font.name, size: fontSize) else {
            fatalError("Can't find font name \(font.name)")
        }
        return customFont
    }
}
