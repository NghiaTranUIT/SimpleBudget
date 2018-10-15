//
//  CategorySelectionViewController.swift
//  SimpleBudget
//
//  Created by khoi on 10/10/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class CategorySelectionViewController: UIViewController, Bindable {
  @IBOutlet var tableView: UITableView!
  
  private var addBarButtonItem: UIBarButtonItem!
  var viewModel: CategorySelectionViewModel!
  
  lazy var dataSources: RxTableViewSectionedAnimatedDataSource<SectionOfCategory> = {
    RxTableViewSectionedAnimatedDataSource<SectionOfCategory>.init(configureCell: { (_, tableView, indexPath, category) -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(for: indexPath, cellClass: CategorySelectionTableViewCell.self)
      cell.categoryLabel.text = category.name
      return cell
    })
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(CategorySelectionTableViewCell.self)

    navigationItem.title = "Select category"
    navigationItem.hidesBackButton = true
    
    addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    navigationItem.rightBarButtonItem = addBarButtonItem
  }

  func setupBinding() {
    viewModel
      .categories
      .bind(to: tableView.rx.items(dataSource: dataSources))
      .disposed(by: rx.disposeBag)

    tableView.rx
      .modelSelected(Category.self)
      .bind(to: viewModel.categorySelected)
      .disposed(by: rx.disposeBag)
    
    addBarButtonItem.rx.action = viewModel.navigateToAddCategoryAction
  }
}
