//
//  SpendingListViewModel.swift
//  SimpleBudget
//
//  Created by khoi on 10/5/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Action
import Foundation
import RxCocoa
import RxFlow
import RxSwift

class SpendingListViewModel: Stepper {
  var spendings: Observable<[Spending]>

  private let budgetService: BudgetServiceType
  private let budgetId: String

  init(budgetService: BudgetServiceType, budgetId: String) {
    self.budgetService = budgetService
    self.budgetId = budgetId

    spendings = budgetService.spending(budgetId: budgetId)
  }
}
