//
//  DependencyContainer.swift
//  StarWars
//
//  Created by Angel Duarte on 19/11/25.
//

import Foundation

protocol HasCharactersRepository {
  var charactersRepository: CharactersRepository { get }
}

protocol HasFilmsRepository {
  var filmsRepository: FilmsRepository { get }
}

typealias HasRepositories = HasCharactersRepository & HasFilmsRepository

final class DependencyContainer: HasRepositories {
  
  let apiClient: APIClient
  let persistenceStack: PersistenceStack
  
  let charactersRepository: CharactersRepository
  let filmsRepository: FilmsRepository
  
  init() {
    self.apiClient = DefaultAPIClient(baseURL: URL(string: "https://swapi.dev/api")!)
    self.persistenceStack = PersistenceStack(modelName: "Model")
    
    let localCharactersDataSource = CoreDataCharactersDataSource(context: persistenceStack.viewContext)
    let localFilmsDataSource = CoreDataFilmsDataSource( context: persistenceStack.viewContext)
    let remoteCharactersDataSource: RemoteCharactersDataSource = DefaultRemoteCharactersDataSource(apiClient: apiClient)
    let remoteFilmsDataSource: RemoteFilmsDataSource = DefaultRemoteFilmsDataSource(apiClient: apiClient)
    
    self.charactersRepository = CharactersRepositoryImpl(remoteDataSource: remoteCharactersDataSource, localDataSource: localCharactersDataSource)
    self.filmsRepository = FilmsRepositoryImpl(remoteDataSource: remoteFilmsDataSource, localDataSource: localFilmsDataSource)
  }
}
