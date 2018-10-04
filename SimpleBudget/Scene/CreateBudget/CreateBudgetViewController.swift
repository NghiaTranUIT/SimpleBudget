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

class CreateBudgetViewController: UIViewController, Bindable {
  @IBOutlet var budgetNameLabel: UITextField!

  @IBOutlet var currencyLabel: UITextField!

  @IBOutlet var createBtn: UIButton!

  var viewModel: CreateBudgetViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func setupBinding() {
    budgetNameLabel.rx.text.orEmpty.bind(to: viewModel.budgetName).disposed(by: rx.disposeBag)
    currencyLabel.rx.text.orEmpty.bind(to: viewModel.budgetCurrency).disposed(by: rx.disposeBag)

    createBtn.rx.action = viewModel.createAction
  }
}
