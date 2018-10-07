//
//  AddSpendingViewController.swift
//  SimpleBudget
//
//  Created by Danh Dang on 10/5/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import UIKit

class AddSpendingViewController: UIViewController, Bindable {
  @IBOutlet var spendingNoteTextField: UITextField!
  @IBOutlet var spendingAmountTextField: UITextField!
  @IBOutlet var addSpendingButton: UIButton!

  var viewModel: AddSpendingViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func setupBinding() {
    spendingNoteTextField.rx.text.orEmpty.bind(to: viewModel.spendingNote).disposed(by: rx.disposeBag)
    spendingAmountTextField.rx.text.orEmpty.bind(to: viewModel.spendingAmountString).disposed(by: rx.disposeBag)

    addSpendingButton.rx.action = viewModel.addSpendingAction
  }
}
