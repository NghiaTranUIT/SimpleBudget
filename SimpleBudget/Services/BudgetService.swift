//
//  BudgetService.swift
//  SimpleBudget
//
//  Created by khoi on 9/30/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

protocol BudgetServiceType {
  func budgets() -> Observable<[Budget]>
}

struct BudgetService: BudgetServiceType {
  private let realm: Realm

  init(config: Realm.Configuration) throws {
    realm = try Realm(configuration: config)
  }

  fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
    do {
      return try action(realm)
    } catch let err {
      print("Failed \(operation) realm with error: \(err)")
      return nil
    }
  }

  func budgets() -> Observable<[Budget]> {
    let result = withRealm("Getting budget list") { (realm) -> Observable<[Budget]> in
      let budgets = realm.objects(Budget.self)
      return Observable.collection(from: budgets).map { $0.toArray() }
    }

    return result ?? .empty()
  }
}
