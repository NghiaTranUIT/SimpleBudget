//
// Created by khoi on 9/30/18.
// Copyright (c) 2018 khoi. All rights reserved.
//

import Foundation
import RxFlow

enum AppStep: Step {
  case walletList
  case createWallet
  case createWalletSuccess

  case transactionList(walletId: String)
  case addTransaction(walletId: String)
  case addTransactionSuccess

  case categorySelection
  case categorySelected(category: Category)
}
