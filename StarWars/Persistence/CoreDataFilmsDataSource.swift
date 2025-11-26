//
//  CoreDataFilmsDataSource.swift
//  StarWars
//
//  Created by Angel Duarte on 25/11/25.
//

import CoreData

protocol LocalFilmsDataSource {
  func save(films: [Film], for characterID: Int) throws
  func fetchFilms(for characterID: Int) throws -> [Film]
}

final class CoreDataFilmsDataSource: LocalFilmsDataSource {
  
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func save(films: [Film], for characterID: Int) throws {
    guard !films.isEmpty else { return }
    
    let charID = Int64(characterID)
    let filmIDs = films.map { Int64($0.id) }
    
    let fetchRequest: NSFetchRequest<CDFilm> = CDFilm.fetchRequest()
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
      NSPredicate(format: "characterID == %lld", charID),
      NSPredicate(format: "id IN %@", filmIDs)
    ])
    
    let existing = try context.fetch(fetchRequest)
    var existingById: [Int64: CDFilm] = [:]
    existing.forEach { existingById[$0.id] = $0 }
    
    for film in films {
      let filmID = Int64(film.id)
      
      let cdFilm = existingById[filmID] ?? CDFilm(context: context)
      
      cdFilm.id = filmID
      cdFilm.characterID = charID
      cdFilm.title = film.title
      cdFilm.director = film.director
      cdFilm.releaseDate = film.releaseDate
    }
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func fetchFilms(for characterID: Int) throws -> [Film] {
    let charID = Int64(characterID)
    
    let fetchRequest: NSFetchRequest<CDFilm> = CDFilm.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "characterID == %lld", charID)
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(key: "releaseDate", ascending: true)
    ]
    
    let results = try context.fetch(fetchRequest)
    
    return results.map { cd in
      Film(id: Int(cd.id), title: cd.title ?? "", director: cd.director ?? "", releaseDate: cd.releaseDate ?? Date())
    }
  }
  
  func clearFilms(for characterID: Int) throws {
    let charID = Int64(characterID)
    
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDFilm.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "characterID == %lld", charID)
    
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    try context.execute(deleteRequest)
    try context.save()
  }
}
