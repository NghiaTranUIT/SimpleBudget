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
  var deleteSpending = PublishSubject<Spending>()

  lazy var navigateToAddSpendingAction: CocoaAction = {
    CocoaAction { [unowned self] in
      self.step.accept(AppStep.addSpending(budgetId: self.budgetId))
      return .empty()
    }
  }()

  private let budgetService: BudgetServiceType
  private let budgetId: String
  private let disposeBag = DisposeBag()

  init(budgetService: BudgetServiceType, budgetId: String) {
    self.budgetService = budgetService
    self.budgetId = budgetId

    spendings = budgetService.spending(budgetId: budgetId)
    deleteSpending.flatMapLatest { (spending) -> Observable<Void> in
      budgetService.deleteSpending(id: spending.id)
    }
    .subscribe()
    .disposed(by: disposeBag)
  }
}
