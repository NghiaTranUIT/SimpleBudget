//
// Created by khoi on 9/30/18.
// Copyright (c) 2018 khoi. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class BudgetListViewController: UIViewController, Bindable {
  var viewModel: BudgetListViewModel!

  lazy var tableView: UITableView = {
    let tv = UITableView(frame: .zero)
    tv.register(BudgetListTableViewCell.self)
    return tv
  }()

  var addBudgetBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

  lazy var dataSources: RxTableViewSectionedAnimatedDataSource<SectionOfBudget> = {
    let dataSources = RxTableViewSectionedAnimatedDataSource<SectionOfBudget>(configureCell: { (_, tableView, indexPath, budget) -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(for: indexPath, cellClass: BudgetListTableViewCell.self)
      cell.nameLabel.text = budget.name
      return cell
    })
    dataSources.canEditRowAtIndexPath = { _, _ in
      true
    }
    return dataSources
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

    navigationItem.rightBarButtonItem = addBudgetBarButtonItem
  }

  func setupBinding() {
    viewModel
      .budgets
      .map { [SectionOfBudget(header: "Budget", items: $0)] }
      .bind(to: tableView.rx.items(dataSource: dataSources))
      .disposed(by: rx.disposeBag)

    tableView.rx
      .modelDeleted(Budget.self)
      .bind(to: viewModel.removeBudget)
      .disposed(by: rx.disposeBag)

    tableView.rx
      .modelSelected(Budget.self)
      .do(onNext: viewModel.navigateToSpendingList)
      .subscribe()
      .disposed(by: rx.disposeBag)

    addBudgetBarButtonItem.rx.action = viewModel.navigateToCreateBudgetAction
  }
}
