//
// Created by khoi on 9/30/18.
// Copyright (c) 2018 khoi. All rights reserved.
//

import Foundation
import RxFlow
import UIKit

class BudgetFlow: Flow {
  var root: Presentable {
    return rootViewController
  }

  private let services: AppServices
  private let rootViewController = UINavigationController()

  init(services: AppServices) {
    self.services = services
  }

  deinit {
    print("\(type(of: self)): \(#function)")
  }

  func navigate(to step: Step) -> NextFlowItems {
    guard let step = step as? AppStep else {
      return .none
    }

    switch step {
    case .walletList:
      return navigateToWalletList()
    case .createWallet:
      return navigateToCreateBudget()
    case .createWalletSuccess:
      return popToRootViewController()
    case let .transactionList(walletId):
      return navigateToTransactionList(walletId: walletId)
    case let .addTransaction(walletId):
      return navigateToAddTransaction(walletId: walletId)
    case .categorySelection:
      return navigateToCategorySelection()
    case let .categorySelected(category):
      return popBackToTransactionList(with: category)
    case .addTransactionSuccess, .addCategorySuccess:
      return popViewController()
    case .addCategory:
      return navigateToAddCategory()
    }
  }

  private func popBackToTransactionList(with selectedCategory: Category) -> NextFlowItems {
    rootViewController.popViewController(animated: true)

    if let addTransactionVc = rootViewController.topViewController as? AddTransactionViewController,
      let addTransactionViewModel = addTransactionVc.viewModel {
      addTransactionViewModel.selectCategory.accept(selectedCategory)
    }

    return .none
  }

  private func navigateToCategorySelection() -> NextFlowItems {
    let viewModel = CategorySelectionViewModel(budgetService: services.budgetService)

    var viewController = CategorySelectionViewController()
    viewController.bindViewModel(to: viewModel)

    rootViewController.pushViewController(viewController, animated: true)

    return .one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
  }

  private func navigateToWalletList() -> NextFlowItems {
    let viewModel = WalletListViewModel(budgetService: services.budgetService)

    var viewController = WalletListViewController()
    viewController.title = "Wallet List"
    viewController.bindViewModel(to: viewModel)

    rootViewController.pushViewController(viewController, animated: true)

    return .one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
  }

  private func navigateToCreateBudget() -> NextFlowItems {
    let viewModel = CreateWalletViewModel(budgetService: services.budgetService)

    var viewController = CreateWalletViewController()
    viewController.title = "Create Wallet"
    viewController.bindViewModel(to: viewModel)

    rootViewController.pushViewController(viewController, animated: true)
    return .one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
  }

  private func navigateToTransactionList(walletId: String) -> NextFlowItems {
    let viewModel = TransactionListViewModel(budgetService: services.budgetService, walletId: walletId)

    var viewController = TransactionListViewController()
    viewController.title = "Transaction List"
    viewController.bindViewModel(to: viewModel)

    rootViewController.pushViewController(viewController, animated: true)
    return .one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
  }

  private func popToRootViewController() -> NextFlowItems {
    rootViewController.popToRootViewController(animated: true)
    return .none
  }

  private func navigateToAddTransaction(walletId: String) -> NextFlowItems {
    let addTransactionViewModel = AddTransactionViewModel(budgetService: services.budgetService, walletId: walletId)

    var addTransactionVC = AddTransactionViewController()
    addTransactionVC.title = "Add Transaction"
    addTransactionVC.bindViewModel(to: addTransactionViewModel)

    rootViewController.pushViewController(addTransactionVC, animated: true)
    return .one(flowItem: NextFlowItem(nextPresentable: addTransactionVC, nextStepper: addTransactionViewModel))
  }

  private func popViewController() -> NextFlowItems {
    rootViewController.popViewController(animated: true)
    return .none
  }

  private func navigateToAddCategory() -> NextFlowItems {
    let viewModel = AddCategoryViewModel(budgetService: services.budgetService)
    var viewController = AddCategoryViewController()
    viewController.bindViewModel(to: viewModel)

    rootViewController.pushViewController(viewController, animated: true)
    return .one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
  }
}
