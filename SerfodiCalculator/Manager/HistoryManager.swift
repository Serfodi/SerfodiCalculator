//
//  HistoryManager.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 01.02.2024.
//

import Foundation
import UIKit

/**
 Упровляет историей вычисленй.
 1. Сохроняет.
 2. Добовляет новые.
 3. Удаляет.
 4. Загружает.
 */
final class HistoryManager {
        
    private let storage = CalculationHistoryStorage()
    
    private var calculations: [Calculation] = []
    
    public var calculationsCount: Int {
        calculations.count
    }
    
    // MARK: init
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        calculations = storage.load()
    }
    deinit {
        save()
    }
    
    @objc private func save() {
        // Подумать над асинхронном сохранении данных
        storage.setData(calculations)
    }
    
    public func calculation(at index: Int) -> Calculation {
        calculations[index]
    }
    
    public func add(calculation: Calculation) {
        calculations.append(calculation)
        save()
    }
    
    public func removeAllDataHistory() {
        calculations.removeAll()
        storage.removeAllHistory()
    }
    
}
