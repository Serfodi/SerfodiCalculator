//
//  CoreDataContextProvider.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.04.2024.
//

import CoreData

final class CoreDataContextProvider  {
    
    private lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "DataStorageModel")
       container.loadPersistentStores(completionHandler: { (_, error) in
          if let error = error as NSError? {
             fatalError("Unresolved error \(error),\(error.userInfo)")
          }
          container.viewContext.automaticallyMergesChangesFromParent = true
       })
       return container
    }()
    
    private lazy var mainContext = persistentContainer.viewContext
}

extension CoreDataContextProvider: CoreDataContextProviding {
    
    func mainQueueContext() -> NSManagedObjectContext {
        self.mainContext
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
