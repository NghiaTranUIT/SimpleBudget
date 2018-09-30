//
//  Reusable.swift
//  SimpleBudget
//
//  Created by khoi on 9/30/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation

protocol Reusable: class {
  static var reusableIdentifier: String { get }
}

extension Reusable {
  static var reusableIdentifier: String {
    return String(describing: self)
  }
}
