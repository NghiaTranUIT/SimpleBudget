//
// Created by khoi on 9/30/18.
// Copyright (c) 2018 khoi. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class WalletListViewController: UIViewController, Bindable {
  var viewModel: WalletListViewModel!

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.register(WalletListTableViewCell.self)
    return tableView
  }()

  var addBudgetBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

  lazy var dataSources: RxTableViewSectionedAnimatedDataSource<SectionOfWallet> = {
    let dataSources = RxTableViewSectionedAnimatedDataSource<SectionOfWallet>
      .init(configureCell: { (_, tableView, indexPath, budget) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(for: indexPath, cellClass: WalletListTableViewCell.self)
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
      .wallets
      .map { [SectionOfWallet(header: "Budget", items: $0)] }
      .bind(to: tableView.rx.items(dataSource: dataSources))
      .disposed(by: rx.disposeBag)

    tableView.rx
      .modelDeleted(Wallet.self)
      .bind(to: viewModel.removeWallet)
      .disposed(by: rx.disposeBag)

    tableView.rx
      .modelSelected(Wallet.self)
      .do(onNext: viewModel.navigateToTransactionList)
      .subscribe()
      .disposed(by: rx.disposeBag)

    addBudgetBarButtonItem.rx.action = viewModel.navigateToCreateWalletAction
  }
}
