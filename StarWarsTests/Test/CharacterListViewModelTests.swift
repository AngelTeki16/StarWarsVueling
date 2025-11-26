//
//  CharacterListViewModelTests.swift
//  StarWars
//
//  Created by Angel Duarte on 26/11/25.
//

import XCTest
@testable import StarWars

final class CharacterListViewModelTests: XCTestCase {
  
  final class CharactersRepositoryMock: CharactersRepository {
    var cachedCharacters: [Character] = []
    var fetchNextPageResult: Result<[Character], Error> = .success([])
    
    func resetPagination() { }
    
    func fetchNextPage() async throws -> [Character] {
      try fetchNextPageResult.get()
    }
    
    func getCachedCharacters() throws -> [Character] {
      cachedCharacters
    }
  }
  
  final class DelegateMock: CommonViewModelDelegate {
    var didUpdateDataCount = 0
    var lastIsLoading: Bool?
    var lastErrorMessage: String?
    
    func didUpdateData() {
      didUpdateDataCount += 1
    }
    
    func didUpdateLoadingState(isLoading: Bool) {
      lastIsLoading = isLoading
    }
    
    func didReceiveError(_ message: String) {
      lastErrorMessage = message
    }
  }
  
  final class CharactersListCoordinatorMock: CharactersListCoordinator {
    
    private(set) var showDetailCalled = false
    private(set) var lastCharacter: Character?
    private(set) var callCount = 0
    
    override func showDetail(for character: Character) {
      showDetailCalled = true
      lastCharacter = character
      callCount += 1
    }
  }
  
  func test_load_usesCachedCharactersFirst() {
    let repo = CharactersRepositoryMock()
    let luke = Character(id: 1, name: "Luke Skywalker", birthYear: "19BBY", gender: .male, filmURLs: [])
    let leia = Character(id: 5, name: "Leia Organa", birthYear: "19BBY", gender: .female, filmURLs: [])
    repo.cachedCharacters = [luke, leia]
    repo.fetchNextPageResult = .success([])
    
    let coordinator = CharactersListCoordinatorMock(navigationController: UINavigationController(), dependecies: DependencyContainer())
    let vm = CharacterListViewModel(coodinator: coordinator, respository: repo)
    let delegate = DelegateMock()
    vm.delegate = delegate
    vm.load()
    
    XCTAssertEqual(vm.items.count, 2)
    XCTAssertEqual(vm.items[0].character.name, "Luke Skywalker")
    XCTAssertEqual(delegate.didUpdateDataCount, 1)
  }
  
  
  func test_updateSearch_filtersCharactersByName() {
    let repo = CharactersRepositoryMock()
    let luke = Character(id: 1, name: "Luke Skywalker", birthYear: "19BBY", gender: .male, filmURLs: [])
    let leia = Character(id: 5, name: "Leia Organa", birthYear: "19BBY", gender: .female, filmURLs: [])
    repo.cachedCharacters = [luke, leia]
    repo.fetchNextPageResult = .success([])

    let coordinator = CharactersListCoordinatorMock(navigationController: UINavigationController(), dependecies: DependencyContainer())
    let vm = CharacterListViewModel(coodinator: coordinator, respository: repo)
    let delegate = DelegateMock()
    vm.delegate = delegate

    vm.load()
    XCTAssertEqual(vm.items.count, 2)
  
    vm.updateSearch(query: "lei")
    
    XCTAssertEqual(vm.items.count, 1)
    XCTAssertEqual(vm.items[0].character.name, "Leia Organa")
  }
}
