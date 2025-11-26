//
//  RemoteFilmsDataSource.swift
//  StarWars
//
//  Created by Angel Duarte on 24/11/25.
//

protocol RemoteFilmsDataSource {
  func fetchFilms(for character: Character) async throws -> [Film]
}

final class DefaultRemoteFilmsDataSource: RemoteFilmsDataSource {
  private let apiClient: APIClient
  
  init(apiClient: APIClient) {
    self.apiClient = apiClient
  }
  
  func fetchFilms(for character: Character) async throws -> [Film] {
    let urls = character.filmURLs
    
    guard !urls.isEmpty else { return [] }
    
    return try await withThrowingTaskGroup(of: Film.self) { group in
      for url in urls {
        group.addTask {
          let dto: FilmDTO = try await self.apiClient.request(url: url)
          return Film(dto: dto)
        }
      }
      var films: [Film] = []
      for try await film in group {
        films.append(film)
      }
      return films
    }
  }
}
