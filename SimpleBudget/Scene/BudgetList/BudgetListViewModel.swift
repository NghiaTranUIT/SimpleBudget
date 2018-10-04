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

  lazy var navigateToCreateBudgetAction: CocoaAction = {
    CocoaAction { [unowned self] in
      self.step.accept(AppStep.createBudget)
      return .empty()
    }
  }()

  private let budgetService: BudgetServiceType

  init(budgetService: BudgetServiceType) {
    self.budgetService = budgetService

    budgets = budgetService.budgets()
  }
}
