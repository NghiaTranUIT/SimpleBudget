//
//  Category+RxDataSources.swift
//  SimpleBudget
//
//  Created by khoi on 10/11/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfCategory {
  var header: String
  var items: [Category]
}

extension SectionOfCategory: AnimatableSectionModelType {
  var identity: String {
    return header
  }

  init(original: SectionOfCategory, items: [Category]) {
    self = original
    self.items = items
  }
}
