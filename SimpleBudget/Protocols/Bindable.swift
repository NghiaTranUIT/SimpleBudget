//
//  Bindable.swift
//  SimpleBudget
//
//  Created by khoi on 9/30/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import RxSwift
import UIKit

protocol Bindable {
  associatedtype ViewModelType
  var viewModel: ViewModelType! { get set }
  func setupBinding()
}

extension Bindable where Self: UIViewController {
  mutating func bindViewModel(to model: Self.ViewModelType) {
    viewModel = model
    loadViewIfNeeded()
    setupBinding()
  }
}
