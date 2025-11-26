//
//  RemoteCharactersDataSource.swift
//  StarWars
//
//  Created by Angel Duarte on 19/11/25.
//

import Foundation

protocol RemoteCharactersDataSource {
  func resetPagination()
  func fetchNextPage() async throws -> [Character]
}

final class DefaultRemoteCharactersDataSource: RemoteCharactersDataSource {
  private let apiClient: APIClient
  private var nextURL: URL?
  private let firstURL = URL(string: "https://swapi.dev/api/people/")!
  
  init(apiClient: APIClient) {
    self.apiClient = apiClient
    self.nextURL = firstURL
  }
  
  func resetPagination() {
    nextURL = firstURL
  }
  
  func fetchNextPage() async throws -> [Character]{
    guard let url = nextURL else { return [] }
    let reponse: PeopleResponseDTO = try await apiClient.request(url: url)
    
    if let nextString = reponse.next,
       let url = URL(string: nextString) {
      nextURL = url
    } else {
      nextURL = nil
    }
    
    return reponse.results.map{ $0.toDomain() }
  }
}
