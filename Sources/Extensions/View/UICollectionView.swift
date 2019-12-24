//
//  UITableView+extension.swift
//  GoFixCustomer
//
//  Created by hieu nguyen on 6/12/18.
//  Copyright © 2018 gofix.vinova.sg. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(T.self, forCellWithReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
    
    func registerXibFile<T: UICollectionViewCell>(_ type: T.Type) {
        self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func registerSupplementaryViewFile<T: UICollectionViewCell>(_ type: T.Type) {
        self.register(UINib(nibName:String(describing: T.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self))
    }
    
    func dequeue<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
            else { fatalError("Could not dequeue cell with type \(T.self)") }
        return cell
    }
    
    func dequeueSupplementaryView<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
            else { fatalError("Could not dequeue cell with type \(T.self)") }
        return cell
    }
    
    func cell<T: UICollectionViewCell>(at indexPath: IndexPath, type: T.Type) -> T {
        guard let cell = self.cellForItem(at: indexPath) as? T else { fatalError("Could not dequeue cell with type \(T.self)") }
        return cell
    }
}
