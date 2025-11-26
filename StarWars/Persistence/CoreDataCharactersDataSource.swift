//
//  CoreDataCharactersDataSource.swift
//  StarWars
//
//  Created by Angel Duarte on 25/11/25.
//

import CoreData

protocol LocalCharactersDataSource {
  func save(characters: [Character]) throws
  func fetchAll() throws -> [Character]
}

final class CoreDataCharactersDataSource: LocalCharactersDataSource {
  
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func save(characters: [Character]) throws {
    guard !characters.isEmpty else { return }
    
    let ids = characters.map { Int64($0.id) }
    
    let fetchRequest: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
    
    let existing = try context.fetch(fetchRequest)
    var existingById: [Int64: CDCharacter] = [:]
    existing.forEach { existingById[$0.id] = $0 }
    
    for character in characters {
      let charID = Int64(character.id)
      
      let cdCharacter = existingById[charID] ?? CDCharacter(context: context)
      
      cdCharacter.id = charID
      cdCharacter.name = character.name
      cdCharacter.birthYear = character.birthYear
      cdCharacter.genderRaw = mapGenderToRaw(character.gender)
      let urlsString = character.filmURLs.map { $0.absoluteString }.joined(separator: ",")
      cdCharacter.filmURLsRaw = urlsString
    }
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func fetchAll() throws -> [Character] {
    let fetchRequest: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    let results = try context.fetch(fetchRequest)
    return results.map { cd in
      let urls: [URL]
      if let raw = cd.filmURLsRaw, !raw.isEmpty {
        urls = raw.split(separator: ",").compactMap { URL(string: String($0)) }
      } else {
        urls = []
      }
      
      return Character(
        id: Int(cd.id),
        name: cd.name ?? "",
        birthYear: cd.birthYear ?? "",
        gender: mapRawToGender(cd.genderRaw ?? ""),
        filmURLs: urls
      )
    }
    
  }
  
  func clear() throws {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCharacter.fetchRequest()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    try context.execute(deleteRequest)
    try context.save()
  }
  
  private func mapGenderToRaw(_ gender: Gender) -> String {
    switch gender {
    case .male: return "male"
    case .female: return "female"
    case .NA: return "n/a"
    case .unknown: return "unknown"
    }
  }
  
  private func mapRawToGender(_ raw: String) -> Gender {
    Gender(rawValue: raw)
  }
}


