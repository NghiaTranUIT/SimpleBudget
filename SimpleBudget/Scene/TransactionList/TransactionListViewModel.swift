//
//  TransactionListViewModel.swift
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

class TransactionListViewModel: Stepper {
  var transactions: Observable<[Transaction]>
  var deleteTransaction = PublishSubject<Transaction>()

  lazy var navigateToAddTransactionAction: CocoaAction = {
    CocoaAction { [unowned self] in
      self.step.accept(AppStep.addTransaction(walletId: self.walletId))
      return .empty()
    }
  }()

  private let budgetService: BudgetServiceType
  private let walletId: String
  private let disposeBag = DisposeBag()

  init(budgetService: BudgetServiceType, walletId: String) {
    self.budgetService = budgetService
    self.walletId = walletId

    transactions = budgetService.transactions(walletId: walletId)
    deleteTransaction.flatMapLatest { (trans) -> Observable<Void> in
      budgetService.deleteTransaction(id: trans.id)
    }
    .subscribe()
    .disposed(by: disposeBag)
  }
}
