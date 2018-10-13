//
//  CategoryViewModel.swift
//  SimpleBudget
//
//  Created by khoi on 10/10/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Action
import Foundation
import RxCocoa
import RxFlow
import RxSwift

final class CategorySelectionViewModel: Stepper {
  var categories: Observable<[SectionOfCategory]>

  let categorySelected = PublishRelay<Category>()

  private let budgetService: BudgetServiceType
  private let disposeBag = DisposeBag()

  init(budgetService: BudgetServiceType) {
    self.budgetService = budgetService

    categories = budgetService.categories().map { [SectionOfCategory(header: "Categories", items: $0)] }

    categorySelected
      .asObservable()
      .take(1)
      .do(onNext: { [weak self] category in
        self?.step.accept(AppStep.categorySelected(category: category))
      })
      .subscribe()
      .disposed(by: disposeBag)
  }
}
