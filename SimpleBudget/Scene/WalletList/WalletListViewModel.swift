//
// Created by khoi on 9/30/18.
// Copyright (c) 2018 khoi. All rights reserved.
//

import Action
import Foundation
import RxFlow
import RxSwift

class WalletListViewModel: Stepper {
  var wallets: Observable<[Wallet]>
  var removeWallet = PublishSubject<Wallet>()

  lazy var navigateToCreateWalletAction: CocoaAction = {
    CocoaAction { [unowned self] in
      self.step.accept(AppStep.createWallet)
      return .empty()
    }
  }()

  private let budgetService: BudgetServiceType
  private let disposeBag = DisposeBag()

  init(budgetService: BudgetServiceType) {
    self.budgetService = budgetService

    wallets = budgetService.wallets()
    removeWallet.flatMapLatest { (budget) -> Observable<Void> in
      budgetService.deleteWallet(id: budget.id)
    }
    .subscribe()
    .disposed(by: disposeBag)
  }

  func navigateToTransactionList(wallet: Wallet) {
    step.accept(AppStep.transactionList(walletId: wallet.id))
  }
}
