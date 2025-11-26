//
//  ProtocolRepository.swift
//  StarWars
//
//  Created by Angel Duarte on 19/11/25.
//

protocol CharactersRepository {
  func resetPagination()
  func fetchNextPage() async throws -> [Character]
  func getCachedCharacters() throws -> [Character]
}

protocol FilmsRepository {
  func getFilms(for character: Character) async throws -> [Film]
  func getCachedFilms(for characterID: Int) throws -> [Film]
}

protocol CommonViewModelDelegate: AnyObject {
  func didUpdateData()
  func didUpdateLoadingState(isLoading: Bool)
  func didReceiveError(_ message: String)
}
