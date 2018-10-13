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
  // Inputs
  let spendingNote = BehaviorRelay<String>(value: "")
  let spendingAmountString = BehaviorRelay<String>(value: "")
  let selectCategory = BehaviorRelay<Category?>(value: nil)

  // Outputs
  let selectedCategoryText: Driver<String>

  // Actions
  lazy var addSpendingAction: CocoaAction = _addSpendingAction()

  lazy var selectCategoryAction: CocoaAction = {
    CocoaAction { [unowned self] in
      Observable.deferred {
        self.step.accept(AppStep.categorySelection)
        return .just(())
      }
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

    selectedCategoryText = selectCategory
      .asObservable()
      .filterNil()
      .map { $0.name }
      .asDriver(onErrorJustReturn: "")
  }

  private func _addSpendingAction() -> CocoaAction {
    return CocoaAction(enabledIf: canAddNewSpending) { [unowned self] in
      Observable.combineLatest(self.spendingNote, self.spendingAmount, self.selectCategory)
        .take(1)
        .flatMapLatest {
          self.budgetService.addSpending(toAccount: self.budgetId, note: $0, amount: $1, category: $2)
        }
        .do(onNext: { _ in
          self.step.accept(AppStep.addSpendingSuccess)
        })
        .map { _ in }
    }
  }
}
