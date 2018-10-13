//
//  BaseEntity+RxDataSources.swift
//  SimpleBudget
//
//  Created by khoi on 10/11/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Foundation
import RxDataSources

extension BaseEntity: IdentifiableType {
  var identity: String {
    return isInvalidated ? "" : id
  }
}
