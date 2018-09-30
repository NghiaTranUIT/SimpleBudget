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

  private let rootViewController = UINavigationController()

  deinit {
    print("\(type(of: self)): \(#function)")
  }

  func navigate(to step: Step) -> NextFlowItems {
    guard let step = step as? AppStep else { return .none }

    switch step {
    case .budgetList:
      return navigateToBudgetList()
    }
  }

  private func navigateToBudgetList() -> NextFlowItems {
    let viewController = BudgetListViewController()
    let viewModel = BudgetListViewModel()
    viewController.title = "Budget List"
    rootViewController.pushViewController(viewController, animated: true)

    return .one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
  }
}
