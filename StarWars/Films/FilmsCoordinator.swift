//
//  FilmsCoordinator.swift
//  StarWars
//
//  Created by Angel Duarte on 24/11/25.
//

import UIKit

final class FilmsCoordinator: Coordinator {
  var navigationController: UINavigationController
  private let character: Character
  private let filmsRepository: FilmsRepository
  
  init(navigationController: UINavigationController, character: Character, filmsRepository: FilmsRepository) {
    self.navigationController = navigationController
    self.character = character
    self.filmsRepository = filmsRepository
  }
  
  func start() {
    let viewModel = FilmsViewModel(coordinator: self, repository: filmsRepository, character: character)
    let view = FilmsViewController()
    view.viewModel = viewModel
    navigationController.pushViewController(view, animated: true)
  }
}
