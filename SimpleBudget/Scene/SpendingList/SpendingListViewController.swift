//
//  SpendingListViewController.swift
//  SimpleBudget
//
//  Created by khoi on 10/5/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class SpendingListViewController: UIViewController, Bindable {
  @IBOutlet var tableView: UITableView!

  var addSpendingBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

  var viewModel: SpendingListViewModel!

  lazy var dataSources: RxTableViewSectionedAnimatedDataSource<SectionOfSpending> = {
    let dataSources = RxTableViewSectionedAnimatedDataSource<SectionOfSpending>(configureCell: { (_, tableView, indexPath, spending) -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(for: indexPath, cellClass: SpendingListTableViewCell.self)
      cell.amountLabel.text = "\(spending.amount)"
      cell.noteLabel.text = spending.note
      return cell
    })
    dataSources.canEditRowAtIndexPath = { _, _ in
      true
    }
    return dataSources
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(SpendingListTableViewCell.self)
    navigationItem.rightBarButtonItem = addSpendingBarButtonItem
  }

  func setupBinding() {
    viewModel
      .spendings
      .map { [SectionOfSpending(header: "Spendings", items: $0)] }
      .bind(to: tableView.rx.items(dataSource: dataSources))
      .disposed(by: rx.disposeBag)

    tableView.rx
      .modelDeleted(Spending.self)
      .bind(to: viewModel.deleteSpending)
      .disposed(by: rx.disposeBag)

    addSpendingBarButtonItem.rx.action = viewModel.navigateToAddSpendingAction
  }
}
