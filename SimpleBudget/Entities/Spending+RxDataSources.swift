//
//  Spending+RxDataSources.swift
//  SimpleBudget
//
//  Created by khoi on 10/5/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation
import RxDataSources

extension Spending: IdentifiableType {
  var identity: String {
    return id
  }
}

struct SectionOfSpending {
  var header: String
  var items: [Spending]
}

extension SectionOfSpending: AnimatableSectionModelType {
  var identity: String {
    return header
  }

  init(original: SectionOfSpending, items: [Spending]) {
    self = original
    self.items = items
  }
}
