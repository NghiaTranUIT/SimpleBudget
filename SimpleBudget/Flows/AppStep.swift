//
// Created by khoi on 9/30/18.
// Copyright (c) 2018 khoi. All rights reserved.
//

import Foundation
import RxFlow

enum AppStep: Step {
  case accountList
  case createAccount
  case createAccountSuccess

  case spendingList(budgetId: String)
  case addSpending(budgetId: String)
  case addSpendingSuccess
}
