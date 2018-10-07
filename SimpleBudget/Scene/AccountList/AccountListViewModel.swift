//
// Created by khoi on 9/30/18.
// Copyright (c) 2018 khoi. All rights reserved.
//

import Action
import Foundation
import RxFlow
import RxSwift

class AccountListViewModel: Stepper {
  var accounts: Observable<[Account]>
  var removeAccount = PublishSubject<Account>()

  lazy var navigateToCreateBudgetAction: CocoaAction = {
    CocoaAction { [unowned self] in
      self.step.accept(AppStep.createAccount)
      return .empty()
    }
  }()

  private let budgetService: BudgetServiceType
  private let disposeBag = DisposeBag()

  init(budgetService: BudgetServiceType) {
    self.budgetService = budgetService

    accounts = budgetService.accounts()
    removeAccount.flatMapLatest { (budget) -> Observable<Void> in
      budgetService.deleteAccount(id: budget.id)
    }
    .subscribe()
    .disposed(by: disposeBag)
  }

  func navigateToSpendingList(budget: Account) {
    step.accept(AppStep.spendingList(budgetId: budget.id))
  }
}
