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

  var viewModel: SpendingListViewModel!

  let dataSources = RxTableViewSectionedAnimatedDataSource<SectionOfSpending>(configureCell: { (_, tableView, indexPath, spending) -> UITableViewCell in
    let cell = tableView.dequeueReusableCell(for: indexPath, cellClass: SpendingListTableViewCell.self)
    cell.amountLabel.text = "\(spending.amount)"
    cell.noteLabel.text = spending.note
    return cell
  })

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(SpendingListTableViewCell.self)
  }

  func setupBinding() {
    viewModel
      .spendings
      .map { [SectionOfSpending(header: "Spendings", items: $0)] }
      .bind(to: tableView.rx.items(dataSource: dataSources))
      .disposed(by: rx.disposeBag)
  }
}
