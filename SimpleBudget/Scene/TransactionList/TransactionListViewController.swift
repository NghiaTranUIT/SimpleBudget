//
//  TransactionListViewController.swift
//  SimpleBudget
//
//  Created by khoi on 10/5/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class TransactionListViewController: UIViewController, Bindable {
  @IBOutlet var tableView: UITableView!

  var addTransactionBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

  var viewModel: TransactionListViewModel!

  lazy var dataSources: RxTableViewSectionedAnimatedDataSource<SectionOfTransaction> = {
    let dataSources = RxTableViewSectionedAnimatedDataSource<SectionOfTransaction>(configureCell: { (_, tableView, indexPath, trans) -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(for: indexPath, cellClass: TransactionListTableViewCell.self)
      cell.amountLabel.text = "\(trans.amount)"
      cell.noteLabel.text = trans.note
      return cell
    })
    dataSources.canEditRowAtIndexPath = { _, _ in
      true
    }
    return dataSources
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(TransactionListTableViewCell.self)
    navigationItem.rightBarButtonItem = addTransactionBarButtonItem
  }

  func setupBinding() {
    viewModel
      .transactions
      .map { [SectionOfTransaction(header: "Transactions", items: $0)] }
      .bind(to: tableView.rx.items(dataSource: dataSources))
      .disposed(by: rx.disposeBag)

    tableView.rx
      .modelDeleted(Transaction.self)
      .bind(to: viewModel.deleteTransaction)
      .disposed(by: rx.disposeBag)

    addTransactionBarButtonItem.rx.action = viewModel.navigateToAddTransactionAction
  }
}
