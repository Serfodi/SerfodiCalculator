//
//  Repository.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.04.2024.
//

import Foundation

protocol AccessableRepository {
   
   associatedtype DomainModel
   
   func save(_ objects: [DomainModel], completion: @escaping ((Result<Void>) -> Void))
   
   func present(by request: RepositorySearchRequest, completion: @escaping ((Result<[DomainModel]>) -> Void))
   
   func eraseAllData(completion: @escaping ((Result<Void>) -> Void))
}

// Запрос
protocol RepositorySearchRequest {
   var predicate: NSPredicate? {get}
   var sortDescriptors: [NSSortDescriptor] {get}
}

//MARK: - Default Repository implementation

class Repository<DomainModel, Entity>: NSObject, AccessableRepository {
   typealias DomainModel = DomainModel
   
   func save(_ objects: [DomainModel], completion: @escaping ((Result<Void>) -> Void)) {
      fatalError("save(_ objects: must be overrided")
   }
   func present(by request: RepositorySearchRequest, completion: @escaping ((Result<[DomainModel]>) -> Void)) {
      fatalError("present(by request: must be overrided")
   }
   func eraseAllData(completion: @escaping ((Result<Void>) -> Void)) {
      fatalError("eraseAllData(completion: must be overrided")
   }
}
