//
//  CharactersRepositoryImpl.swift
//  StarWars
//
//  Created by Angel Duarte on 19/11/25.
//

final class CharactersRepositoryImpl: CharactersRepository {
  private let remoteDataSource: RemoteCharactersDataSource
  private let localDataSource: LocalCharactersDataSource
  
  private var hasMorePages = true
  
  init(remoteDataSource: RemoteCharactersDataSource,
       localDataSource: LocalCharactersDataSource) {
    self.remoteDataSource = remoteDataSource
    self.localDataSource = localDataSource
  }
  
  func resetPagination() {
    hasMorePages = true
    remoteDataSource.resetPagination()
  }
  
  func fetchNextPage() async throws -> [Character] {
    guard hasMorePages else { return [] }
    
    do {
      let characters = try await remoteDataSource.fetchNextPage()
      
      if characters.isEmpty {
        hasMorePages = false
        return []
      }
      
      try localDataSource.save(characters: characters)
      return characters
      
    } catch {
      let cached = try localDataSource.fetchAll()
      hasMorePages = false
      return cached
    }
  }
  
  func getCachedCharacters() throws -> [Character] {
    try localDataSource.fetchAll()
  }
}
