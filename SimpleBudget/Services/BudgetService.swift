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
  // Account
  func accounts() -> Observable<[Account]>
  func createAccount(name: String, currency: String) -> Observable<Account>
  func deleteAccount(id: String) -> Observable<Void>

  func spending(accountId: String) -> Observable<[Spending]>
  func addSpending(toAccount accountId: String, note: String, amount: Int) -> Observable<Spending>
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

  func accounts() -> Observable<[Account]> {
    let result = withRealm("Getting account list") { (realm) -> Observable<[Account]> in
      return Observable.array(from: realm.objects(Account.self))
    }

    return result ?? .empty()
  }

  func createAccount(name: String, currency: String) -> Observable<Account> {
    let result = withRealm("Creating new account") { (realm) -> Observable<Account> in
      let account = Account()
      account.name = name
      account.currency = currency

      guard let _ = try? realm.write({ realm.add(account) }) else {
        return Observable.error(BudgetServiceError.creationFailed)
      }

      return Observable.just(account)
    }

    return result ?? .empty()
  }

  func deleteAccount(id: String) -> Observable<Void> {
    let result = withRealm("Deleting account \(id)") { (realm) -> Observable<Void> in

      guard let accountToDelete = realm.object(ofType: Account.self, forPrimaryKey: id) else {
        return .just(())
      }

      guard let _ = try? realm.write({
        realm.delete(accountToDelete.spendings)
        realm.delete(accountToDelete)
      }) else {
        return Observable.error(BudgetServiceError.deletionFailed)
      }

      return .just(())
    }

    return result ?? .empty()
  }

  func spending(accountId: String) -> Observable<[Spending]> {
    let result = withRealm("Getting spendings for account Id \(accountId)") { (realm) -> Observable<[Spending]> in
      guard let budget = realm.object(ofType: Account.self, forPrimaryKey: accountId) else {
        return .just([])
      }
      return Observable.array(from: budget.spendings)
    }

    return result ?? .empty()
  }

  func addSpending(toAccount accountId: String, note: String, amount: Int) -> Observable<Spending> {
    let result = withRealm("Adding new spending") { (realm) -> Observable<Spending> in

      guard let budget = realm.object(ofType: Account.self, forPrimaryKey: accountId) else {
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
    let result = withRealm("Delete a spending id \(id)") { (realm) -> Observable<Void> in

      guard let accountToDelete = realm.object(ofType: Spending.self, forPrimaryKey: id) else {
        return .just(())
      }

      guard let _ = try? realm.write({
        realm.delete(accountToDelete)
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
