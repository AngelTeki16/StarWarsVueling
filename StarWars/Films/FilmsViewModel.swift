//
//  FilmsViewModel.swift
//  StarWars
//
//  Created by Angel Duarte on 24/11/25.
//

import Foundation

struct FilmCellViewModel {
  let titleText: String
  let directorText: String
  let releaseDateText: String
}

class FilmsViewModel {
  let coordinator: FilmsCoordinator
  let repository: FilmsRepository
  let character: Character
  weak var delegate: CommonViewModelDelegate?
  private(set) var items: [FilmCellViewModel] = []
  var title: String {
    character.name
  }
  
  init(coordinator: FilmsCoordinator, repository: FilmsRepository, character: Character) {
    self.coordinator = coordinator
    self.repository = repository
    self.character = character
  }
  
  func load() {
    if let cached = try? repository.getCachedFilms(for: character.id),
       !cached.isEmpty {
      self.items = Self.mapFilmsToViewModels(cached)
      delegate?.didUpdateData()
    }
    
    if !character.filmURLs.isEmpty {
      loadFilms()
    }
  }
  
  private func loadFilms() {
    delegate?.didUpdateLoadingState(isLoading: true)
    Task {
      do {
        let films = try await repository.getFilms(for: character)
        let mapped = Self.mapFilmsToViewModels(films)
        
        await MainActor.run {
          self.items = mapped
          self.delegate?.didUpdateLoadingState(isLoading: false)
          self.delegate?.didUpdateData()
        }
      } catch {
        await MainActor.run {
          self.delegate?.didUpdateLoadingState(isLoading: false)
          self.delegate?.didReceiveError("Mostrando películas almacenadas \(error).")
        }
      }
    }
  }
  
  private static func mapFilmsToViewModels(_ films: [Film]) -> [FilmCellViewModel] {
    let sorted = films.sorted { $0.releaseDate < $1.releaseDate }
    
    let df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .none
    
    return sorted.map { film in
      FilmCellViewModel(
        titleText: film.title,
        directorText: "Director: \(film.director)",
        releaseDateText: "Release: \(df.string(from: film.releaseDate))"
      )
    }
  }
}
