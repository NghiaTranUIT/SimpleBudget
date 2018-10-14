//
//  AddTransactionViewModel.swift
//  SimpleBudget
//
//  Created by Danh Dang on 10/5/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Action
import RxCocoa
import RxFlow
import RxSwift

class AddTransactionViewModel: Stepper {
  // Inputs
  let transactionNote = BehaviorRelay<String>(value: "")
  let transactionAmountString = BehaviorRelay<String>(value: "")
  let selectCategory = BehaviorRelay<Category?>(value: nil)

  // Outputs
  let selectedCategoryText: Driver<String>

  // Actions
  lazy var addTransactionAction: CocoaAction = _addTransactionAction()

  lazy var selectCategoryAction: CocoaAction = {
    CocoaAction { [unowned self] in
      Observable.deferred {
        self.step.accept(AppStep.categorySelection)
        return .just(())
      }
    }
  }()

  private let canAddNewTransaction: Observable<Bool>
  private let transactionAmount: Observable<Int>

  private let walletId: String
  private let budgetService: PersistenceServiceType

  init(budgetService: PersistenceServiceType, walletId: String) {
    self.budgetService = budgetService
    self.walletId = walletId

    transactionAmount = transactionAmountString
      .filter { !$0.isEmpty }
      .map { Int($0) ?? 0 }

    canAddNewTransaction = Observable
      .combineLatest(transactionNote, transactionAmount)
      .map { transNote, amount in
        !transNote.isEmpty && amount != 0
      }
      .distinctUntilChanged()

    selectedCategoryText = selectCategory
      .asObservable()
      .filterNil()
      .map { $0.name }
      .asDriver(onErrorJustReturn: "")
  }

  private func _addTransactionAction() -> CocoaAction {
    return CocoaAction(enabledIf: canAddNewTransaction) { [unowned self] in
      Observable.combineLatest(self.transactionNote, self.transactionAmount, self.selectCategory)
        .take(1)
        .flatMapLatest {
          self.budgetService.addTransaction(toWallet: self.walletId, note: $0, amount: $1, category: $2)
        }
        .do(onNext: { _ in
          self.step.accept(AppStep.addTransactionSuccess)
        })
        .map { _ in }
    }
  }
}
