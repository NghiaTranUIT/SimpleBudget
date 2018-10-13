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
  case addTransactionFailed
  case deleteTransactionFailed
}

protocol BudgetServiceType {
  // Wallet
  func wallets() -> Observable<[Wallet]>
  func createWallet(name: String, currency: String) -> Observable<Wallet>
  func deleteWallet(id: String) -> Observable<Void>

  func transactions(walletId: String) -> Observable<[Transaction]>
  func addTransaction(toWallet walletId: String, note: String, amount: Int, category: Category?) -> Observable<Transaction>
  func deleteTransaction(id: String) -> Observable<Void>

  // Category
  func categories() -> Observable<[Category]>

  // Seed Data
  func seedDataIfNeeded()
}

struct BudgetService: BudgetServiceType {
  private let realm: Realm
  private let userDefaults: UserDefaults

  private enum UserDefaultsKeys: String {
    case isInitialDataSeeded
  }

  init(config: Realm.Configuration, userDefaults: UserDefaults = UserDefaults.standard) throws {
    self.userDefaults = userDefaults
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

  func wallets() -> Observable<[Wallet]> {
    let result = withRealm("Getting wallet list") { (realm) -> Observable<[Wallet]> in
      return Observable.array(from: realm.objects(Wallet.self))
    }

    return result ?? .empty()
  }

  func createWallet(name: String, currency: String) -> Observable<Wallet> {
    let result = withRealm("Creating new wallet") { (realm) -> Observable<Wallet> in
      let wallet = Wallet()
      wallet.name = name
      wallet.currency = currency

      guard let _ = try? realm.write({ realm.add(wallet) }) else {
        return Observable.error(BudgetServiceError.creationFailed)
      }

      return Observable.just(wallet)
    }

    return result ?? .empty()
  }

  func deleteWallet(id: String) -> Observable<Void> {
    let result = withRealm("Deleting wallet \(id)") { (realm) -> Observable<Void> in

      guard let walletToDelete = realm.object(ofType: Wallet.self, forPrimaryKey: id) else {
        return .just(())
      }

      guard let _ = try? realm.write({
        realm.delete(walletToDelete.transactions)
        realm.delete(walletToDelete)
      }) else {
        return Observable.error(BudgetServiceError.deletionFailed)
      }

      return .just(())
    }

    return result ?? .empty()
  }

  func transactions(walletId: String) -> Observable<[Transaction]> {
    let result = withRealm("Getting transactions for wallet Id \(walletId)") { (realm) -> Observable<[Transaction]> in
      guard let wallet = realm.object(ofType: Wallet.self, forPrimaryKey: walletId) else {
        return .just([])
      }
      return Observable.array(from: wallet.transactions)
    }

    return result ?? .empty()
  }

  func addTransaction(toWallet walletId: String, note: String, amount: Int, category: Category?) -> Observable<Transaction> {
    let result = withRealm("Adding new transaction") { (realm) -> Observable<Transaction> in

      guard let wallet = realm.object(ofType: Wallet.self, forPrimaryKey: walletId) else {
        return Observable.error(BudgetServiceError.addTransactionFailed)
      }

      let trans = Transaction()
      trans.note = note
      trans.amount = amount
      trans.category = category

      guard let _ = try? realm.write({
        wallet.transactions.append(trans)
      }) else {
        return Observable.error(BudgetServiceError.addTransactionFailed)
      }

      return Observable.just(trans)
    }

    return result ?? .empty()
  }

  func deleteTransaction(id: String) -> Observable<Void> {
    let result = withRealm("Delete a transaction id \(id)") { (realm) -> Observable<Void> in

      guard let walletToDelete = realm.object(ofType: Transaction.self, forPrimaryKey: id) else {
        return .just(())
      }

      guard let _ = try? realm.write({
        realm.delete(walletToDelete)
      }) else {
        return Observable.error(BudgetServiceError.deleteTransactionFailed)
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

  func seedDataIfNeeded() {
    if userDefaults.bool(forKey: UserDefaultsKeys.isInitialDataSeeded.rawValue) {
      return
    }

    _ = withRealm("Seeding data", action: { (realm) -> Void in
      let seedCategories = ["Shopping", "Education", "Food", "Rent", "Misc"].map { name -> Category in
        let c = Category()
        c.name = name
        return c
      }

      let defaultWallet = Wallet()
      defaultWallet.name = "Cash"
      defaultWallet.currency = "USD"

      try? realm.write {
        realm.add(defaultWallet)
        realm.add(seedCategories)
      }

      userDefaults.set(true, forKey: UserDefaultsKeys.isInitialDataSeeded.rawValue)
    })
  }
}
