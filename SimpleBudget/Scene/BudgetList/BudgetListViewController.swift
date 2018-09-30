//
// Created by khoi on 9/30/18.
// Copyright (c) 2018 khoi. All rights reserved.
//

import Foundation
import RxDataSources
import UIKit

class BudgetListViewController: UIViewController, Bindable {
  var viewModel: BudgetListViewModel!

  lazy var tableView: UITableView = {
    let tv = UITableView(frame: .zero)
    tv.register(BudgetListTableViewCell.self)
    return tv
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(tableView)

    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ])
  }

  func setupBinding() {
    viewModel.budgets.bind(to: tableView.rx.items(cellIdentifier: "BudgetListTableViewCell", cellType: BudgetListTableViewCell.self)) { _, model, cell in
      cell.nameLabel.text = model.name
    }.disposed(by: rx.disposeBag)
  }
}
