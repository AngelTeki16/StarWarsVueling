//
//  PersistenceStack.swift
//  StarWars
//
//  Created by Angel Duarte on 25/11/25.
//

import CoreData

final class PersistenceStack {
  
  let persistentContainer: NSPersistentContainer
  var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  lazy var backgroundContext: NSManagedObjectContext = {
    let context = persistentContainer.newBackgroundContext()
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    context.automaticallyMergesChangesFromParent = true
    return context
  }()
  
  init(modelName: String) {
    persistentContainer = NSPersistentContainer(name: modelName)
    persistentContainer.loadPersistentStores{ _, error in
      if let error = error {
        fatalError("Error cargando core Data \(error)")
      }
    }
    
    persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
  }
}
