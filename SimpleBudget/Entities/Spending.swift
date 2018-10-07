//
//  Spending.swift
//  SimpleBudget
//
//  Created by khoi on 9/29/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation
import RealmSwift

class Spending: Object {
  @objc dynamic var id = UUID().uuidString
  @objc dynamic var note: String = ""
  @objc dynamic var amount: Int = 0
  @objc dynamic var date: Date = Date()
  let account = LinkingObjects(fromType: Account.self, property: "spendings")

  override static func primaryKey() -> String? {
    return "id"
  }
}
