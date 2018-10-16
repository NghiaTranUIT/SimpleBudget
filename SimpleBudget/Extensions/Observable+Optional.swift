//
//  Observable+Optional.swift
//  SimpleBudget
//
//  Created by khoi on 10/13/18.
//  Copyright © 2018 SimpleBudget. All rights reserved.
//

import Foundation
import RxSwift

public protocol OptionalType {
  associatedtype Wrapped

  var value: Wrapped? { get }
}

extension Optional: OptionalType {
  public var value: Wrapped? {
    return self
  }
}

extension ObservableType where E: OptionalType {
  public func filterNil() -> Observable<E.Wrapped> {
    return flatMap { element -> Observable<E.Wrapped> in
      guard let value = element.value else {
        return Observable<E.Wrapped>.empty()
      }
      return Observable<E.Wrapped>.just(value)
    }
  }
}
