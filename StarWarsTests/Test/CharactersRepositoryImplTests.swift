//
//  CharactersRepositoryImplTests.swift
//  StarWarsTests
//
//  Created by Angel Duarte on 26/11/25.
//

import XCTest
@testable import StarWars

final class CharactersRepositoryImplTests: XCTestCase {
  
  enum DummyError: Error {
    case network
  }
  
  final class RemoteCharactersDataSourceMock: RemoteCharactersDataSource {
    var shouldThrow = false
    var nextPageCharacters: [Character] = []
    var resetPaginationCalled = false
    
    func resetPagination() {
      resetPaginationCalled = true
    }
    
    func fetchNextPage() async throws -> [Character] {
      if shouldThrow {
        throw DummyError.network
      }
      return nextPageCharacters
    }
  }
  
  final class LocalCharactersDataSourceMock: LocalCharactersDataSource {
    var savedCharacters: [Character] = []
    var cachedCharacters: [Character] = []
    
    func save(characters: [Character]) throws {
      savedCharacters.append(contentsOf: characters)
    }
    
    func fetchAll() throws -> [Character] {
      cachedCharacters
    }
    
    func clear() throws { }
  }
  
  func test_fetchNextPage_whenRemoteFails_returnsLocalAndStopsPagination() async throws {
    let remote = RemoteCharactersDataSourceMock()
    remote.shouldThrow = true
    
    let local = LocalCharactersDataSourceMock()
    let han = Character(id: 10, name: "Han Solo", birthYear: "29BBY", gender: .male, filmURLs: [])
    local.cachedCharacters = [han]
    
    let repo = CharactersRepositoryImpl(remoteDataSource: remote, localDataSource: local)
    let result = try await repo.fetchNextPage()
    XCTAssertEqual(result.count, 1)
    XCTAssertEqual(result.first?.name, "Han Solo")
    
    let second = try await repo.fetchNextPage()
    XCTAssertTrue(second.isEmpty)
  }
  
  func test_fetchNextPage_whenRemoteSucceeds_savesToLocal_andReturnsRemote() async throws {
      let remote = RemoteCharactersDataSourceMock()
      let local = LocalCharactersDataSourceMock()
      
      let luke = Character(id: 1, name: "Luke Skywalker", birthYear: "19BBY", gender: .male, filmURLs: [])
      let leia = Character(id: 5, name: "Leia Organa", birthYear: "19BBY", gender: .female, filmURLs: [])
      
      remote.shouldThrow = false
      remote.nextPageCharacters = [luke, leia]
      local.cachedCharacters = []
      
      let repo = CharactersRepositoryImpl(remoteDataSource: remote, localDataSource: local)
      let result = try await repo.fetchNextPage()
      
      XCTAssertEqual(result.count, 2)
      XCTAssertEqual(result[0].name, "Luke Skywalker")
      XCTAssertEqual(result[1].name, "Leia Organa")
      XCTAssertEqual(local.savedCharacters.count, 2)
      XCTAssertEqual(local.savedCharacters[0].name, "Luke Skywalker")

      remote.nextPageCharacters = []
      
      let second = try await repo.fetchNextPage()
      XCTAssertTrue(second.isEmpty)
  }
}
