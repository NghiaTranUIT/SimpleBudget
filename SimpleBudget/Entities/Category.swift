//
//  Category.swift
//  SimpleBudget
//
//  Created by khoi on 10/7/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var id = UUID().uuidString
  @objc dynamic var name: String = ""
}
