//
//  AddTransactionViewController.swift
//  SimpleBudget
//
//  Created by Danh Dang on 10/5/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController, Bindable {
  @IBOutlet var transactionNoteTextField: UITextField!
  @IBOutlet var transactionAmountTextField: UITextField!
  @IBOutlet var addTransactionButton: UIButton!
  @IBOutlet var selectCategoryBtn: UIButton!
  @IBOutlet var selectedCategoryLabel: UILabel!

  var viewModel: AddTransactionViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func setupBinding() {
    transactionNoteTextField.rx.text.orEmpty.bind(to: viewModel.transactionNote).disposed(by: rx.disposeBag)
    transactionAmountTextField.rx.text.orEmpty.bind(to: viewModel.transactionAmountString).disposed(by: rx.disposeBag)

    viewModel.selectedCategoryText.drive(selectedCategoryLabel.rx.text).disposed(by: rx.disposeBag)

    addTransactionButton.rx.action = viewModel.addTransactionAction
    selectCategoryBtn.rx.action = viewModel.selectCategoryAction
  }
}
