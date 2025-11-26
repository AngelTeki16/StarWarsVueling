//
//  CharacterListViewModel.swift
//  StarWars
//
//  Created by Angel Duarte on 19/11/25.
//

class CharacterListViewModel {
  weak var delegate: CommonViewModelDelegate?
  weak var coodinator: CharactersListCoordinator?
  private let repository: CharactersRepository
  private(set) var items: [CharacterCellViewModel] = []
  private var allCharacters: [Character] = []
  private var isLoading = false
  private var hasMorePages = true
  private var searchQuery: String = ""
  private(set) var adsEnabled: Bool = false
  
  init(coodinator: CharactersListCoordinator, respository: CharactersRepository) {
    self.coodinator = coodinator
    self.repository = respository
  }
    
  func load() {
    if let cached = try? repository.getCachedCharacters(), !cached.isEmpty {
      self.allCharacters = cached
      applyFilterAndSort()
      delegate?.didUpdateData()
    }
    
    repository.resetPagination()
    loadPage()
  }
  
  func loadPage() {
    guard !isLoading, hasMorePages else { return }
    isLoading = true
    delegate?.didUpdateLoadingState(isLoading: true)
    
    Task { [weak self] in
      guard let self = self else { return }
      do {
        let newCharacters = try await self.repository.fetchNextPage()
        
        await MainActor.run {
          if newCharacters.isEmpty {
            self.hasMorePages = false
          } else {
            let merged = Array(Set(self.allCharacters + newCharacters))
            self.allCharacters = merged
            self.applyFilterAndSort()
          }
          self.isLoading = false
          self.delegate?.didUpdateData()
          self.delegate?.didUpdateLoadingState(isLoading: false)
        }
        
      } catch {
        await MainActor.run {
          self.isLoading = false
          self.hasMorePages = false
          self.delegate?.didUpdateLoadingState(isLoading: false)
          self.delegate?.didReceiveError("Error al obtener personajes \(error)")
        }
      }
    }
  }
  
  func refresh() {
    hasMorePages = true
    allCharacters.removeAll()
    items.removeAll()
    delegate?.didUpdateData()
    repository.resetPagination()
    loadPage()
  }

  func updateSearch(query: String) {
    searchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
    applyFilterAndSort()
    delegate?.didUpdateData()
  }
  
  private func applyFilterAndSort() {
    let base: [Character]
    
    if searchQuery.isEmpty {
      base = allCharacters
    } else {
      let q = searchQuery.lowercased()
      base = allCharacters.filter {
        $0.name.lowercased().contains(q) ||
        $0.birthYear.lowercased().contains(q)
      }
    }
    
    let sorted = sortCharacters(base)
    items = sorted.map(CharacterCellViewModel.init)
  }

  func didSelectItem(at index: Int) {
    let character = items[index].character
    coodinator?.showDetail(for: character)
  }
  
  private func sortCharacters(_ characters: [Character]) -> [Character] {
    characters.sorted { a, b in
      switch (a.birthYearNumeric, b.birthYearNumeric) {
      case let (v1?, v2?):
        return v1 < v2
      case (_?, nil):
        return true
      case (nil, _?):
        return false
      case (nil, nil):
        return a.name < b.name
      }
    }
  }

  func setAdsEnabled(_ enabled: Bool) {
    adsEnabled = enabled
    delegate?.didUpdateData()
  }
}
