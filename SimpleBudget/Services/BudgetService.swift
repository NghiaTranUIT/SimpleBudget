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
  case deletionFailed
  case addSpendingFailed
  case deleteSpendingFailed
}

protocol BudgetServiceType {
  // Budget
  func budgets() -> Observable<[Budget]>
  func createBudget(name: String, currency: String) -> Observable<Budget>
  func deleteBudget(id: String) -> Observable<Void>

  // Spending
  func spending(budgetId: String) -> Observable<[Spending]>
  func addSpending(toBudget budgetId: String, note: String, amount: Int) -> Observable<Spending>
  func deleteSpending(id: String) -> Observable<Void>

  // Category
  func categories() -> Observable<[Category]>

  // Seed Data
  func seedData()
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

  func deleteBudget(id: String) -> Observable<Void> {
    let result = withRealm("Delete a budget") { (realm) -> Observable<Void> in

      guard let budgetToDelete = realm.object(ofType: Budget.self, forPrimaryKey: id) else {
        return .just(())
      }

      guard let _ = try? realm.write({
        realm.delete(budgetToDelete.spendings)
        realm.delete(budgetToDelete)
      }) else {
        return Observable.error(BudgetServiceError.deletionFailed)
      }

      return .just(())
    }

    return result ?? .empty()
  }

  func spending(budgetId: String) -> Observable<[Spending]> {
    let result = withRealm("Getting spendings for budget Id \(budgetId)") { (realm) -> Observable<[Spending]> in
      guard let budget = realm.object(ofType: Budget.self, forPrimaryKey: budgetId) else {
        return .just([])
      }

      return Observable.collection(from: budget.spendings).map { $0.toArray() }
    }

    return result ?? .empty()
  }

  func addSpending(toBudget budgetId: String, note: String, amount: Int) -> Observable<Spending> {
    let result = withRealm("Adding new spending") { (realm) -> Observable<Spending> in

      guard let budget = realm.object(ofType: Budget.self, forPrimaryKey: budgetId) else {
        return Observable.error(BudgetServiceError.addSpendingFailed)
      }

      let spending = Spending()
      spending.note = note
      spending.amount = amount

      guard let _ = try? realm.write({
        budget.spendings.append(spending)
      }) else {
        return Observable.error(BudgetServiceError.addSpendingFailed)
      }

      return Observable.just(spending)
    }

    return result ?? .empty()
  }

  func deleteSpending(id: String) -> Observable<Void> {
    let result = withRealm("Delete a spending in budget") { (realm) -> Observable<Void> in

      guard let spendingToDelete = realm.object(ofType: Spending.self, forPrimaryKey: id) else {
        return .just(())
      }

      guard let _ = try? realm.write({
        realm.delete(spendingToDelete)
      }) else {
        return Observable.error(BudgetServiceError.deleteSpendingFailed)
      }

      return .just(())
    }

    return result ?? .empty()
  }

  func categories() -> Observable<[Category]> {
    let result = withRealm("Getting categories list") { (realm) -> Observable<[Category]> in
      return Observable.array(from: realm.objects(Category.self))
    }

    return result ?? .empty()
  }

  func seedData() {
    _ = withRealm("Seeding data", action: { (realm) -> Void in
      let seedCategories = ["Shopping", "Education", "Food", "Rent", "Misc"].map { name -> Category in
        let c = Category()
        c.name = name
        return c
      }
      try? realm.write {
        realm.add(seedCategories)
      }
    })
  }
}
