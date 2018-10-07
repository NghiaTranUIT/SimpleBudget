//
//  Budget+RxDataSources.swift
//  SimpleBudget
//
//  Created by Danh Dang on 10/6/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Foundation
import RxDataSources

extension Account: IdentifiableType {
  var identity: String {
    return isInvalidated ? "" : id
  }
}

struct SectionOfBudget {
  var header: String
  var items: [Account]
}

extension SectionOfBudget: AnimatableSectionModelType {
  var identity: String {
    return header
  }

  init(original: SectionOfBudget, items: [Account]) {
    self = original
    self.items = items
  }
}
