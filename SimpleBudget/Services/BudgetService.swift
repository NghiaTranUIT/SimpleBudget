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

enum BudgetServiceError: Error {
  case creationFailed
}

protocol BudgetServiceType {
  func budgets() -> Observable<[Budget]>
  func createBudget(name: String, currency: String) -> Observable<Budget>
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

  func createBudget(name: String, currency: String) -> Observable<Budget> {
    let result = withRealm("Creating new budget") { (realm) -> Observable<Budget> in
      let budget = Budget()
      budget.name = name
      budget.currency = currency

      guard let _ = try? realm.write({ realm.add(budget) }) else {
        return Observable.error(BudgetServiceError.creationFailed)
      }

      return Observable.just(budget)
    }

    return result ?? .empty()
  }
}
