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
  @objc dynamic var name = ""
  @objc dynamic var amount: Int = 0
  @objc dynamic var currency = ""
  @objc dynamic var startDate = Date(timeIntervalSinceNow: 0)
  @objc dynamic var endDate: Date?
  let spends = List<Spend>()
}
