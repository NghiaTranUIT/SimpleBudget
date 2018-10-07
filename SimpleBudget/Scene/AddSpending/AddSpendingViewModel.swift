//
//  AddSpendingViewModel.swift
//  SimpleBudget
//
//  Created by Danh Dang on 10/5/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Action
import RxCocoa
import RxFlow
import RxSwift

class AddSpendingViewModel: Stepper {
  let spendingNote = BehaviorSubject<String>(value: "")
  let spendingAmountString = BehaviorSubject<String>(value: "")

  lazy var addSpendingAction: CocoaAction = {
    CocoaAction(enabledIf: canAddNewSpending) { [unowned self] in
      Observable.combineLatest(self.spendingNote, self.spendingAmount)
        .take(1)
        .flatMapLatest {
          self.budgetService.addSpending(toAccount: self.budgetId, note: $0, amount: $1)
        }
        .do(onNext: { _ in
          self.step.accept(AppStep.addSpendingSuccess)
        })
        .map { _ in }
    }
  }()

  private let canAddNewSpending: Observable<Bool>
  private let spendingAmount: Observable<Int>

  private let budgetId: String
  private let budgetService: BudgetServiceType

  init(budgetService: BudgetServiceType, budgetId: String) {
    self.budgetService = budgetService
    self.budgetId = budgetId

    spendingAmount = spendingAmountString
      .filter { !$0.isEmpty }
      .map { Int($0) ?? 0 }

    canAddNewSpending = Observable
      .combineLatest(spendingNote, spendingAmount)
      .map { spendingNote, spendingAmount in
        !spendingNote.isEmpty && spendingAmount != 0
      }
      .distinctUntilChanged()
  }
}
