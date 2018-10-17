//
//  PersistenceServiceTest.swift
//  SimpleBudgetTests
//
//  Created by khoi on 10/14/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Nimble
import Quick
import RealmSwift
import RxBlocking
import RxSwift

@testable import SimpleBudget

class PersistenceServiceTest: QuickSpec {
  override func spec() {
    var subject: PersistenceService!

    beforeEach {
      subject = try! PersistenceService(config: Realm.Configuration(inMemoryIdentifier: UUID().uuidString))
    }

    describe("Wallets") {
      it("should emits [] when there is no wallet") {
        let wallets = try! subject.wallets().toBlocking().first()!

        expect(wallets.count).to(equal(0))
      }

      it("should be able to create wallets") {
        _ = try! subject.createWallet(name: "Cash", currency: "USD").toBlocking().first()!
        _ = try! subject.createWallet(name: "Bank", currency: "VND").toBlocking().first()!

        let wallets = try! subject.wallets().toBlocking().first()!

        expect(wallets.count).to(equal(2))
      }

      it("should delete the wallet properly") {
        let tobeDeletedWallet = try! subject.createWallet(name: "Cash", currency: "USD").toBlocking().first()!
        let remainWallet = try! subject.createWallet(name: "Bank", currency: "VND").toBlocking().first()!

        try! subject.deleteWallet(id: tobeDeletedWallet.id).toBlocking().first()!
        let wallets = try! subject.wallets().toBlocking().first()!

        expect(wallets.count).to(equal(1))
        expect(wallets.contains(remainWallet)).to(be(true))
      }
    }

    describe("Transactions") {
      var wallet: Wallet!

      beforeEach {
        wallet = try! subject.createWallet(name: "Bank", currency: "VND").toBlocking().first()!
      }

      it("should emits [] when there is no transc") {
        let trans = try! subject.transactions(walletId: wallet.id).toBlocking().first()!

        expect(trans).to(equal([]))
      }

      it("should emits [] for invalid wallet id") {
        let trans = try! subject.transactions(walletId: "Invalid ID").toBlocking().first()!

        expect(trans).to(equal([]))
      }

      it("should be able to create transactions") {
        let amountOfTrans = 5

        (0 ..< amountOfTrans).forEach {
          _ = subject.addTransaction(toWallet: wallet.id, note: "\(amountOfTrans)", amount: $0, category: nil).toBlocking()
        }

        let trans = try! subject.transactions(walletId: wallet.id).toBlocking().first()!
        expect(trans.count).to(equal(5))
      }

      describe("Categories") {
        it("should emits [] when there is no cats") {
          let trans = try! subject.categories().toBlocking().first()!

          expect(trans).to(equal([]))
        }

        it("should be able to create categories") {
          let n = 5

          (0 ..< n).forEach {
            _ = subject.addCategory(name: "\($0)").toBlocking()
          }

          let cats = try! subject.categories().toBlocking().first()!.map { $0.name }
          expect(cats).to(equal(["0", "1", "2", "3", "4"]))
        }
      }
    }
  }
}
