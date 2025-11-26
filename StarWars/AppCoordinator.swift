//
//  MainCoordinator.swift
//  StarWars
//
//  Created by Angel Duarte on 19/11/25.
//

import UIKit

protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get }
  func start()
}

class AppCoordinator: Coordinator {
  
  let window: UIWindow
  let navigationController: UINavigationController
  
  private var chilCoordinators: [Coordinator] = []
  
  init(window: UIWindow) {
    self.window = window
    self.navigationController = UINavigationController()
  }
  
  func start() {
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }
}
