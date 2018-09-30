//
//  AppFlow.swift
//  SimpleBudget
//
//  Created by khoi on 9/30/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Foundation
import RxFlow
import UIKit

class AppFlow: Flow {
  private let window: UIWindow

  var root: Presentable {
    return window
  }

  init(window: UIWindow) {
    self.window = window
  }

  deinit {
    print("\(type(of: self)): \(#function)")
  }

  func navigate(to step: Step) -> NextFlowItems {
    guard let step = step as? AppStep else {
      return .none
    }

    switch step {
    case .budgetList:
      return navigateToBudgetList()
    }
  }

  private func navigateToBudgetList() -> NextFlowItems {
    let budgetFlow = BudgetFlow()

    Flows.whenReady(flow1: budgetFlow) { [unowned self] root in
      self.window.rootViewController = root
    }

    return .one(flowItem: NextFlowItem(nextPresentable: budgetFlow, nextStepper: OneStepper(withSingleStep: AppStep.budgetList)))
  }
}
