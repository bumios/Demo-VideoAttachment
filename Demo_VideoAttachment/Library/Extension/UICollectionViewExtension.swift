//
//  UICollectionViewExtension.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/25/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(nibWithCellClass: T.Type) {
        let cellIdentifier = String(describing: nibWithCellClass)
        register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }

    func dequeueCell<T: UICollectionViewCell>(_ withClass: T.Type, indexPath: IndexPath) -> T {
        let cellIdentifier = String(describing: withClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? T else {
            fatalError("Can't register with \(withClass)")
        }
        return cell
    }
}
