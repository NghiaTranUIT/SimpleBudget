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

typealias BudgetCreationInput = (name: String, currency: String)

class CreateBudgetViewModel: Stepper {
  let budgetName = BehaviorSubject<String>(value: "")
  let budgetCurrency = BehaviorSubject<String>(value: "")

  lazy var createAction: CocoaAction = {
    CocoaAction(enabledIf: createEnabled) { [unowned self] in
      Observable
        .combineLatest(self.budgetName, self.budgetCurrency)
        .take(1)
        .flatMap {
          self.budgetService.createAccount(name: $0, currency: $1)
        }
        .do(onNext: { _ in
          self.step.accept(AppStep.createBudgetSuccess)
        })
        .map { _ in }
    }
  }()

  private var createEnabled: Observable<Bool>

  private let budgetService: BudgetServiceType

  init(budgetService: BudgetServiceType) {
    self.budgetService = budgetService

    createEnabled = Observable
      .combineLatest(budgetName, budgetCurrency)
      .map { name, currency in !name.isEmpty && !currency.isEmpty }
      .distinctUntilChanged()
  }
}
