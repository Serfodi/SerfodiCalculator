//
//  CoreDataManager.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.04.2024.
//

import CoreData

//MARK: - Helpers for CoreData Rrpository default implementation

protocol DBContextProviding {
    func mainQueueContext() -> NSManagedObjectContext
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}

//MARK: EntityMapper

class EntityMapper<DomainModel, Entity> {
    
    func convert(_ entity: Entity) -> DomainModel? {
        fatalError("convert(_ entity: Entity: must be overrided")
    }
    
    func update(_ entity: Entity, by model: DomainModel) {
        fatalError("supdate(_ entity: Entity: must be overrided")
    }
}



class CoreDataManager<DomainModel, Entity>: Repository<DomainModel, Entity>, NSFetchedResultsControllerDelegate {
    
    private let associatedEntityName: String
    private let contextSource: DBContextProviding
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private let entityMapper: EntityMapper<DomainModel, Entity>
    
    // MARK: - init
    
    init(contextSource: DBContextProviding, autoUpdateSearchRequest: RepositorySearchRequest?, entityMapper: EntityMapper<DomainModel, Entity>) {
        self.contextSource = contextSource
        self.associatedEntityName = String(describing: Entity.self)
        self.entityMapper = entityMapper
        super.init()
        guard let request = autoUpdateSearchRequest else { return }
        self.fetchedResultsController = configureactualSearchedDataUpdating(request)
    }
    
    // MARK: - Repository
    
    override func save(_ objects: DomainModel, completion: @escaping ((Result<Void>) -> Void)) {
        contextSource.performBackgroundTask() { context in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.associatedEntityName)
            
            let entityForUpdate: Entity? = NSEntityDescription.insertNewObject(forEntityName: self.associatedEntityName, into: context) as? Entity
            guard let entity = entityForUpdate else { return }
            
            self.entityMapper.update(entity, by: objects)
            self.applyChanges(context: context, completion: completion)
        }
    }
    
    override func present(by request: RepositorySearchRequest, completion: @escaping ((Result<[DomainModel]>) -> Void)) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: associatedEntityName)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = request.sortDescriptors
        contextSource.performBackgroundTask() { context in
            do {
                let rawData = try context.fetch(fetchRequest)
                guard rawData.isEmpty == false else {return completion(Result(value: [])) }
                guard let results = rawData as? [Entity] else {
                    completion(Result(value: []))
                    assertionFailure(DBRepositoryErrors.entityTypeError.localizedDescription)
                    return
                }
                let converted = results.compactMap({ return self.entityMapper.convert($0) })
                completion(Result(value: converted))
            } catch {
                completion(Result(error: error))
            }
        }
    }
    
    override func eraseAllData(completion: @escaping ((Result<Void>) -> Void)) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: associatedEntityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        contextSource.performBackgroundTask({ context in
            do {
                let result = try context.execute(batchDeleteRequest)
                guard let deleteResult = result as? NSBatchDeleteResult,
                      let ids = deleteResult.result as? [NSManagedObjectID]
                else {
                    completion(Result.error(DBRepositoryErrors.noChangesInRepository))
                    return
                }
                
                let changes = [NSDeletedObjectsKey: ids]
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: changes,
                    into: [self.contextSource.mainQueueContext()]
                )
                
                completion(Result(value: ()))
                return
            } catch {
                completion(Result.error(error))
            }
        })
    }
    
    // MARK: - Saving support
    
    private func applyChanges(context: NSManagedObjectContext, completion: ((Result<Void>) -> Void)? = nil) {
        switch context.hasChanges {
        case true:
            do {
                try context.save()
            } catch {
                completion?(Result.error(error))
            }
            completion?(Result(value: ()))
        case false:
            completion?(Result(error: DBRepositoryErrors.noChangesInRepository))
        }
    }
    
    private func configureactualSearchedDataUpdating(_ request: RepositorySearchRequest) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: associatedEntityName)
        fetchRequest.predicate = request.predicate
        fetchRequest.sortDescriptors = request.sortDescriptors
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: contextSource.mainQueueContext(),
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }
}
