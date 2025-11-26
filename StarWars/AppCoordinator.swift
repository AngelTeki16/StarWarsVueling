//
//  AppCoordinator.swift
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
  private let dependencies: DependencyContainer
  
  private var chilCoordinators: [Coordinator] = []
  
  init(window: UIWindow,
       dependencies:DependencyContainer = DependencyContainer()) {
    self.window = window
    self.navigationController = UINavigationController()
    self.dependencies = dependencies
  }
  
  func start() {
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    showCharacterList()
  }
  
  private func showCharacterList() {
    let characterListCoordinator = CharactersListCoordinator(navigationController: self.navigationController, dependecies: dependencies)
    chilCoordinators.append(characterListCoordinator)
    characterListCoordinator.start()
  }
}
