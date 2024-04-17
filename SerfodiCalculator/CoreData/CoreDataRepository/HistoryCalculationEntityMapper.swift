//
//  HistoryCalculationEntityMapper.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.04.2024.
//

import CoreData

final class HistoryCalculationEntityMapper: EntityMapper<HistoryCalculation, CalculateEntity> {
    
    override func convert(_ entity: CalculateEntity) -> HistoryCalculation? {
        guard  let calculation = entity.calculation?.unbox,
               let date = entity.date
        else { return nil }
        return HistoryCalculation(calculation: calculation,
                           date: date)
    }
    
    override func update(_ entity: CalculateEntity, by model: HistoryCalculation) {
        entity.date = model.date
        entity.calculation = CalculationBox(model.calculation)
    }
 
    override func entityAccessorKey(_ entity: CalculateEntity) -> String {
        entity.date?.description ?? ""
    }
    
    override func entityAccessorKey(_ object: HistoryCalculation) -> String {
        object.date.description
    }
}
