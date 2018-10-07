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
    case .budgetList:
      return navigateToBudgetList()
    case .createBudget:
      return navigateToCreateBudget()
    case .createBudgetSuccess:
      return popToRootViewController()
    case let .spendingList(budgetId):
      return navigateToSpendingList(budgetId: budgetId)
    case let .addSpending(budgetId):
      return navigateToAddSpending(budgetId: budgetId)
    case .addSpendingSuccess:
      return popViewController()
    }
  }

  private func navigateToBudgetList() -> NextFlowItems {
    let viewModel = BudgetListViewModel(budgetService: services.budgetService)

    var viewController = BudgetListViewController()
    viewController.title = "Budget List"
    viewController.bindViewModel(to: viewModel)

    rootViewController.pushViewController(viewController, animated: true)

    return .one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
  }

  private func navigateToCreateBudget() -> NextFlowItems {
    let viewModel = CreateBudgetViewModel(budgetService: services.budgetService)

    var viewController = CreateBudgetViewController()
    viewController.title = "Create Budget"
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
