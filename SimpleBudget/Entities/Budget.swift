//
//  Budget.swift
//  SimpleBudget
//
//  Created by khoi on 9/29/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation
import RealmSwift

class Budget: Object {
  @objc dynamic var id = UUID().uuidString
  @objc dynamic var name = ""
  @objc dynamic var currency = ""
  let spends = List<Spend>()

  override static func primaryKey() -> String? {
    return "id"
  }
}
