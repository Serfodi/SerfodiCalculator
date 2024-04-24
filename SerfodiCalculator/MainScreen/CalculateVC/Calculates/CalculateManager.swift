//
//  CalculateManager.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 18.04.2024.
//

import Foundation

protocol CalculateManager {
    
    var countItems: Int {get}
    
    func result() async throws -> Double
    
    func eraseAll()
    
    func addNumber(_ number: Double)
    
    func addOperation(_ operation: Operation)
    
    /// Добовляет опирации для повторного вычисления при нажатии на `Равно "="`.
    /// Берет последнии действия, если они есть, и добовляет их в масив `calculationHistory`
    func addLastOperation()
    
    /// Удаляет массив исории `calculationHistory`
    /// Запоминает последнее введое число `lastNumber`
    ///
    /// - Parameter completion: Принимает текущию массив `calculationHistory` до удаления.
    func removeHistory(completion: @escaping ([CalculationHistoryItem]) -> ())
}


