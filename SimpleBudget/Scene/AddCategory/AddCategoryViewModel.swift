//
//  AddCategoryViewModel.swift
//  SimpleBudget
//
//  Created by Huong Do on 10/15/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Action
import Foundation
import RxFlow
import RxSwift

class AddCategoryViewModel: Stepper {

  let categoryName = BehaviorSubject<String>(value: "")
  
  private let budgetService: PersistenceServiceType
  private var createEnabled: Observable<Bool>
  
  lazy var categoryAddedAction: CocoaAction = {
    CocoaAction(enabledIf: createEnabled) { [unowned self] in
      self.categoryName
        .flatMap { self.budgetService.addCategory(name: $0) }
        .do(onNext: { _ in self.step.accept(AppStep.addCategorySuccess) })
        .map { _ in }
    }
  }()
  
  init(budgetService: PersistenceServiceType) {
    self.budgetService = budgetService
    
    createEnabled = categoryName
      .map { !$0.isEmpty }
      .distinctUntilChanged()
  }
}