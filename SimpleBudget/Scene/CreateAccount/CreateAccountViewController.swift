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

class CreateAccountViewController: UIViewController, Bindable {
  @IBOutlet var accountNameLabel: UITextField!

  @IBOutlet var currencyLabel: UITextField!

  @IBOutlet var createBtn: UIButton!

  var viewModel: CreateAccountViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func setupBinding() {
    accountNameLabel.rx.text.orEmpty.bind(to: viewModel.accountName).disposed(by: rx.disposeBag)
    currencyLabel.rx.text.orEmpty.bind(to: viewModel.accountCurrency).disposed(by: rx.disposeBag)

    createBtn.rx.action = viewModel.createAction
  }
}
