//
//  UITableView+Reusable.swift
//  SimpleBudget
//
//  Created by khoi on 9/30/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell: Reusable {}

extension UITableView {
  func register<T: UITableViewCell>(_ cellClass: T.Type) {
    register(cellClass, forCellReuseIdentifier: cellClass.reusableIdentifier)
  }

  func register<T: UITableViewCell>(_ cellClass: T.Type) where T: NibLoadableView {
    let bundle = Bundle(for: T.self)
    let nib = UINib(nibName: T.nibName, bundle: bundle)
    register(nib, forCellReuseIdentifier: cellClass.reusableIdentifier)
  }

  func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellClass: T.Type = T.self) -> T {
    guard let cell = self.dequeueReusableCell(withIdentifier: cellClass.reusableIdentifier, for: indexPath) as? T else {
      fatalError("Failed to dequeue cell with identifier: \(cellClass.reusableIdentifier)")
    }
    return cell
  }
}
