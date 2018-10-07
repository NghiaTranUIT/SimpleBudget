//
// Created by khoi on 9/30/18.
// Copyright (c) 2018 khoi. All rights reserved.
//

import Action
import Foundation
import RxFlow
import RxSwift

class BudgetListViewModel: Stepper {
  var budgets: Observable<[Account]>
  var removeBudget = PublishSubject<Account>()

  lazy var navigateToCreateBudgetAction: CocoaAction = {
    CocoaAction { [unowned self] in
      self.step.accept(AppStep.createBudget)
      return .empty()
    }
  }()

  private let budgetService: BudgetServiceType
  private let disposeBag = DisposeBag()

  init(budgetService: BudgetServiceType) {
    self.budgetService = budgetService

    budgets = budgetService.accounts()
    removeBudget.flatMapLatest { (budget) -> Observable<Void> in
      budgetService.deleteAccount(id: budget.id)
    }
    .subscribe()
    .disposed(by: disposeBag)
  }

  func navigateToSpendingList(budget: Account) {
    step.accept(AppStep.spendingList(budgetId: budget.id))
  }
}
