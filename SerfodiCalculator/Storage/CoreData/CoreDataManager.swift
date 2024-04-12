//
//  CoreDataManager.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 10.04.2024.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let presistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Expression")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        presistentContainer.viewContext
    }
    
    // MARK: - Expression Action
    
    
    func saveExpression(witch result: Double) {
        let expression = Expression(context: viewContext)
        expression.result = result
        saveContext()
    }
    
    func eraseAllData(completion: @escaping ((Result<Void>) -> Void)) {
        presistentContainer.performBackgroundTask { context in
            context.deletedObjects
            completion(Result(value: ()))
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getFetchedResultsController(entityName: String, keyForSort: [String]) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequst = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var sortDescriptor: [NSSortDescriptor] = []
        
        keyForSort.forEach {
            let sorted  = NSSortDescriptor(key: $0, ascending: true)
            sortDescriptor.append(sorted)
        }
        fetchRequst.sortDescriptors = sortDescriptor
        
        // init
        let fetchResultContainer = NSFetchedResultsController<NSFetchRequestResult>(
            fetchRequest: fetchRequst,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchResultContainer
    }
}
