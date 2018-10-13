//
//  CreateBudgetViewController.swift
//  SimpleBudget
//
//  Created by khoi on 10/2/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import Action
import RxCocoa
import RxSwift
import UIKit

class CreateWalletViewController: UIViewController, Bindable {
  @IBOutlet var walletNameLabel: UITextField!

  @IBOutlet var currencyLabel: UITextField!

  @IBOutlet var createBtn: UIButton!

  var viewModel: CreateWalletViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func setupBinding() {
    walletNameLabel.rx.text.orEmpty.bind(to: viewModel.walletName).disposed(by: rx.disposeBag)
    currencyLabel.rx.text.orEmpty.bind(to: viewModel.walletCurrency).disposed(by: rx.disposeBag)

    createBtn.rx.action = viewModel.createAction
  }
}
