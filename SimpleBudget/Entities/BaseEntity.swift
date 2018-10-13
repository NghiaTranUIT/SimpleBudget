//
//  BaseEntity.swift
//  SimpleBudget
//
//  Created by khoi on 10/11/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class BaseEntity: Object {
  @objc dynamic var id = UUID().uuidString

  override static func primaryKey() -> String? {
    return "id"
  }
}
