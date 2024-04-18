//
//  CoreDataManager.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.04.2024.
//

import UIKit

final class CoreDataCalculateSearchRequest: RepositorySearchRequest {
    
    var predicate: NSPredicate? { nil }
    
    var sortDescriptors: [NSSortDescriptor] {
        [.init(key: "date", ascending: true)]
    }
}

class CoreDataManager {
    
    private var repository: CoreDataRepository<HistoryCalculation, CalculateEntity>?
    
    private var calculations: [HistoryCalculation] = []
    
    public var calculationsCount: Int {
        calculations.count
    }
    
    init() {
        let contextProvider = CoreDataContextProvider()
        let entityMapper = HistoryCalculationEntityMapper()
        let repository = CoreDataRepository(contextSource: contextProvider,
                                        autoUpdateSearchRequest: nil,
                                        entityMapper: entityMapper)
        self.repository = repository
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        load()
    }
    
    @objc private func save() {
        repository?.save(calculations, completion: { result in
            switch result {
            case .success():
                ()
            case .error(let error):
                print(error)
            }
        })
    }
    
    public func calculation(at index: Int) -> HistoryCalculation {
        calculations[index]
    }
    
    public func add(_ historyCalculation: HistoryCalculation) {
        calculations.append(historyCalculation)
        save()
    }
    
    public func removeAllDataHistory(complite: @escaping (Result<Void>) -> ()) {
        calculations.removeAll()
        repository?.eraseAllData(completion: complite)
    }
    
    public func dataСapacity() -> Int {
        calculations.count
    }
    
    // MARK: - Helper
    
    private func load() {
        repository?.present(by: CoreDataCalculateSearchRequest(), completion: { result in
            switch result {
            case .success(let data):
                self.calculations = data
            case .error(let error):
                print(error)
            }
        })
    }
}
