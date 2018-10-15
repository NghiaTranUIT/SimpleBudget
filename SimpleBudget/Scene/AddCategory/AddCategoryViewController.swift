//
//  AddCategoryViewController.swift
//  SimpleBudget
//
//  Created by Huong Do on 10/15/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Action
import RxCocoa
import RxSwift
import UIKit

class AddCategoryViewController: UIViewController, Bindable {

  @IBOutlet weak var nameTextField: UITextField!
  
  var doneBarButtonItem: UIBarButtonItem!
  
  var viewModel: AddCategoryViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    navigationItem.rightBarButtonItem = doneBarButtonItem
  }

  func setupBinding() {
    nameTextField.rx.text.orEmpty
      .bind(to: viewModel.categoryName)
      .disposed(by: rx.disposeBag)
    
    doneBarButtonItem.rx.action = viewModel.categoryAddedAction
  }
}
