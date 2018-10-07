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

class CreateAccountViewModel: Stepper {
  let accountName = BehaviorSubject<String>(value: "")
  let accountCurrency = BehaviorSubject<String>(value: "")

  lazy var createAction: CocoaAction = {
    CocoaAction(enabledIf: createEnabled) { [unowned self] in
      Observable
        .combineLatest(self.accountName, self.accountCurrency)
        .take(1)
        .flatMap {
          self.budgetService.createAccount(name: $0, currency: $1)
        }
        .do(onNext: { _ in
          self.step.accept(AppStep.createAccountSuccess)
        })
        .map { _ in }
    }
  }()

  private var createEnabled: Observable<Bool>

  private let budgetService: BudgetServiceType

  init(budgetService: BudgetServiceType) {
    self.budgetService = budgetService

    createEnabled = Observable
      .combineLatest(accountName, accountCurrency)
      .map { name, currency in !name.isEmpty && !currency.isEmpty }
      .distinctUntilChanged()
  }
}
