//
//  CreateBudgetViewModel.swift
//  SimpleBudget
//
//  Created by khoi on 10/2/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Action
import Foundation
import RxCocoa
import RxFlow
import RxSwift

class CreateWalletViewModel: Stepper {
  let walletName = BehaviorSubject<String>(value: "")
  let walletCurrency = BehaviorSubject<String>(value: "")

  lazy var createAction: CocoaAction = {
    CocoaAction(enabledIf: createEnabled) { [unowned self] in
      Observable
        .combineLatest(self.walletName, self.walletCurrency)
        .take(1)
        .flatMap {
          self.budgetService.createWallet(name: $0, currency: $1)
        }
        .do(onNext: { _ in
          self.step.accept(AppStep.createWalletSuccess)
        })
        .map { _ in }
    }
  }()

  private var createEnabled: Observable<Bool>

  private let budgetService: PersistenceServiceType

  init(budgetService: PersistenceServiceType) {
    self.budgetService = budgetService

    createEnabled = Observable
      .combineLatest(walletName, walletCurrency)
      .map { name, currency in !name.isEmpty && !currency.isEmpty }
      .distinctUntilChanged()
  }
}
