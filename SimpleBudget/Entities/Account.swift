//
//  Budget.swift
//  SimpleBudget
//
//  Created by khoi on 9/29/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation
import RealmSwift

final class Account: BaseEntity {
  @objc dynamic var name = ""
  @objc dynamic var currency = ""
  let spendings = List<Spending>()
}
