//
//  Budget+RxDataSources.swift
//  SimpleBudget
//
//  Created by Danh Dang on 10/6/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfWallet {
  var header: String
  var items: [Wallet]
}

extension SectionOfWallet: AnimatableSectionModelType {
  var identity: String {
    return header
  }

  init(original: SectionOfWallet, items: [Wallet]) {
    self = original
    self.items = items
  }
}
