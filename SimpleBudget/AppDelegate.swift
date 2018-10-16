//
//  AppDelegate.swift
//  SimpleBudget
//
//  Created by khoi on 9/29/18.
//  Copyright © 2018 khoi. All rights reserved.
//

import NSObject_Rx
import RealmSwift
import RxFlow
import RxSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow? = UIWindow(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: UIScreen.main.bounds.width,
                                                 height: UIScreen.main.bounds.height))

  var coordinator = Coordinator()
  var appFlow: AppFlow!

  let disposeBag = DisposeBag()

  // swiftlint:disable force_try
  let budgetService = try! PersistenceService(config: Realm.Configuration(deleteRealmIfMigrationNeeded: true))

  lazy var appServices = {
    AppServices(budgetService: budgetService)
  }()

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    guard let window = window else {
      return false
    }

    window.makeKeyAndVisible()

    coordinator.rx.didNavigate.subscribe(onNext: { flow, step in
      print("did navigate to flow=\(flow) and step=\(step)")
    }).disposed(by: disposeBag)

    appFlow = AppFlow(window: window, services: appServices)

    appServices.budgetService.seedDataIfNeeded()

    coordinator.coordinate(flow: appFlow, withStepper: OneStepper(withSingleStep: AppStep.walletList))

    return true
  }
}

struct AppServices {
  let budgetService: PersistenceServiceType
}
