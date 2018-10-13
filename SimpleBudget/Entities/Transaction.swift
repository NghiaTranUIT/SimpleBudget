//
//  Transaction.swift
//  SimpleBudget
//
//  Created by khoi on 9/29/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation
import RealmSwift

final class Transaction: BaseEntity {
  @objc dynamic var note: String = ""
  @objc dynamic var amount: Int = 0
  @objc dynamic var date: Date = Date()
  @objc dynamic var category: Category?
  let wallet = LinkingObjects(fromType: Wallet.self, property: "transactions")
}
