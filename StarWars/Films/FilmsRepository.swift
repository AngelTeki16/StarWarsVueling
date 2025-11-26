//
//  FilmsRepository.swift
//  StarWars
//
//  Created by Angel Duarte on 24/11/25.
//

final class FilmsRepositoryImpl: FilmsRepository {
  private let remoteDataSource: RemoteFilmsDataSource
  private let localDataSource: LocalFilmsDataSource
  
  init(remoteDataSource: RemoteFilmsDataSource,
       localDataSource: LocalFilmsDataSource) {
    self.remoteDataSource = remoteDataSource
    self.localDataSource = localDataSource
  }
  
  func getFilms(for character: Character) async throws -> [Film] {
    let hasFilms = !character.filmURLs.isEmpty
    if hasFilms {
      do {
        let films = try await remoteDataSource.fetchFilms(for: character)
        try localDataSource.save(films: films, for: character.id)
        return films
      } catch {
        if let cached = try? localDataSource.fetchFilms(for: character.id),
           !cached.isEmpty {
          return cached
        } else {
          throw error
        }
      }
    } else {
      let cached = try localDataSource.fetchFilms(for: character.id)
      return cached
    }
  }
  
  func getCachedFilms(for characterID: Int) throws -> [Film] {
    try localDataSource.fetchFilms(for: characterID)
  }
}
