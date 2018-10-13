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
    guard let step = step as? AppStep else { return .none }

    switch step {
    case .accountList:
      return navigateToBudgetList()
    case .createAccount:
      return navigateToCreateBudget()
    case .createAccountSuccess:
      return popToRootViewController()
    case let .spendingList(budgetId):
      return navigateToSpendingList(budgetId: budgetId)
    case let .addSpending(budgetId):
      return navigateToAddSpending(budgetId: budgetId)
    case .categorySelection:
      return navigateToCategorySelection()
    case let .categorySelected(category):
      return popBackToSpendingList(with: category)
    case .addSpendingSuccess:
      return popViewController()
    }
  }

  private func popBackToSpendingList(with selectedCategory: Category) -> NextFlowItems {
    rootViewController.popViewController(animated: true)

    if let addSpendingVc = rootViewController.topViewController as? AddSpendingViewController,
      let addSpendingViewModel = addSpendingVc.viewModel {
      addSpendingViewModel.selectCategory.accept(selectedCategory)
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

  private func navigateToBudgetList() -> NextFlowItems {
    let viewModel = AccountListViewModel(budgetService: services.budgetService)

    var viewController = AccountListViewController()
    viewController.title = "Account List"
    viewController.bindViewModel(to: viewModel)

    rootViewController.pushViewController(viewController, animated: true)

    return .one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
  }

  private func navigateToCreateBudget() -> NextFlowItems {
    let viewModel = CreateAccountViewModel(budgetService: services.budgetService)

    var viewController = CreateAccountViewController()
    viewController.title = "Create Account"
    viewController.bindViewModel(to: viewModel)

    rootViewController.pushViewController(viewController, animated: true)
    return .one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
  }

  private func navigateToSpendingList(budgetId: String) -> NextFlowItems {
    let viewModel = SpendingListViewModel(budgetService: services.budgetService, budgetId: budgetId)

    var viewController = SpendingListViewController()
    viewController.title = "Spending List"
    viewController.bindViewModel(to: viewModel)

    rootViewController.pushViewController(viewController, animated: true)
    return .one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
  }

  private func popToRootViewController() -> NextFlowItems {
    rootViewController.popToRootViewController(animated: true)
    return .none
  }

  private func navigateToAddSpending(budgetId: String) -> NextFlowItems {
    let addSpendingViewModel = AddSpendingViewModel(budgetService: services.budgetService, budgetId: budgetId)

    var addSpendingVC = AddSpendingViewController()
    addSpendingVC.title = "Add Spending"
    addSpendingVC.bindViewModel(to: addSpendingViewModel)

    rootViewController.pushViewController(addSpendingVC, animated: true)
    return .one(flowItem: NextFlowItem(nextPresentable: addSpendingVC, nextStepper: addSpendingViewModel))
  }

  private func popViewController() -> NextFlowItems {
    rootViewController.popViewController(animated: true)
    return .none
  }
}
