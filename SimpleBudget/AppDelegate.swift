//
//  AppDelegate.swift
//  SimpleBudget
//
//  Created by khoi on 9/29/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import RxFlow
import RxSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow? = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

  var coordinator = Coordinator()
  var appFlow: AppFlow!

  let disposeBag = DisposeBag()

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    guard let window = window else { return false }

    window.makeKeyAndVisible()

    coordinator.rx.didNavigate.subscribe(onNext: { flow, step in
      print("did navigate to flow=\(flow) and step=\(step)")
    }).disposed(by: disposeBag)

    appFlow = AppFlow(window: window)

    coordinator.coordinate(flow: appFlow, withStepper: OneStepper(withSingleStep: AppStep.budgetList))
    return true
  }
}
