//
// Created by khoi on 9/30/18.
// Copyright (c) 2018 khoi. All rights reserved.
//

import Action
import Foundation
import RxFlow
import RxSwift

class BudgetListViewModel: Stepper {
  var budgets: Observable<[Budget]>
  var removeBudget = PublishSubject<Budget>()

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

    budgets = budgetService.budgets()
    removeBudget.flatMapLatest { (budget) -> Observable<Void> in
      budgetService.deleteBudget(id: budget.id)
    }
    .subscribe()
    .disposed(by: disposeBag)
  }
}
