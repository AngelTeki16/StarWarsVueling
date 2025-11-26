//
//  CharactersListCoordinator.swift
//  StarWars
//
//  Created by Angel Duarte on 19/11/25.
//

import UIKit

class CharactersListCoordinator: Coordinator {
  var navigationController: UINavigationController
  private let dependecies: DependencyContainer
  
  init(navigationController: UINavigationController, dependecies: DependencyContainer) {
    self.navigationController = navigationController
    self.dependecies = dependecies
  }
  
  func start() {
    let viewModel = CharacterListViewModel(coodinator: self, respository: dependecies.charactersRepository)
    let view = CharacterListViewController()
    view.viewModel = viewModel
    navigationController.pushViewController(view, animated: true)
  }
  
  func showDetail(for character: Character) {
    let coordinator = FilmsCoordinator(
      navigationController: navigationController,
      character: character,
      filmsRepository: dependecies.filmsRepository
    )
    coordinator.start()
  }
}
