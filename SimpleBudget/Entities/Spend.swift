//
//  Spending.swift
//  SimpleBudget
//
//  Created by khoi on 9/29/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation
import RealmSwift

class Spend: Object {
  @objc dynamic var id = UUID().uuidString
  @objc var note: String = ""
  @objc var amount: Int = 0
  let budget = LinkingObjects(fromType: Budget.self, property: "spends")
}
