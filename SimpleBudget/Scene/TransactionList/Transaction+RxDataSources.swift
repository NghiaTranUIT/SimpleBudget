//
//  Transaction+RxDataSources.swift
//  SimpleBudget
//
//  Created by khoi on 10/5/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfTransaction {
  var header: String
  var items: [Transaction]
}

extension SectionOfTransaction: AnimatableSectionModelType {
  var identity: String {
    return header
  }

  init(original: SectionOfTransaction, items: [Transaction]) {
    self = original
    self.items = items
  }
}
