//
//  UITableViewExtension.swift
//  ElectricalCalculator
//
//  Created by Duy Tran N. on 2/23/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(nibWithCellClass: T.Type) {
        let cellIdentifier = String(describing: nibWithCellClass)
        register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    func dequeueCell<T: UITableViewCell>(_ withClass: T.Type, indexPath: IndexPath) -> T {
        let cellIdentifier = String(describing: withClass)
        guard let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? T else {
            fatalError("Can't register with \(withClass)")
        }
        return cell
    }
}
