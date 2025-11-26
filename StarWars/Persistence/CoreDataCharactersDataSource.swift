//
//  ObjectManager.swift
//  StarWars
//
//  Created by Angel Duarte on 25/11/25.
//

import CoreData

@objc(CDCharacter)
class CDCharacter: NSManagedObject {
  @NSManaged var id: Int64
  @NSManaged var name: String
  @NSManaged var birthYear: String
  @NSManaged var genderRaw: String
}

@objc(CDFilm)
class CDFilm: NSManagedObject {
  @NSManaged var id: Int64
  @NSManaged var title: String
  @NSManaged var director: String
  @NSManaged var releaseDate: Date
  @NSManaged var characterID: Int64
}
