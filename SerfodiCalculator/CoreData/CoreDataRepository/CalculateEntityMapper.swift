//
//  CalculateEntityMapper.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.04.2024.
//

import CoreData

final class CalculateEntityMapper: EntityMapper<Calculation, CalculateEntity> {
    
    override func convert(_ entity: CalculateEntity) -> Calculation? {
        Calculation(expression: [], result: entity.result, date: entity.date!)
    }
    
    override func update(_ entity: CalculateEntity, by model: Calculation) {
        entity.result = model.result
        entity.date = model.date
    }
 
    override func entityAccessorKey(_ entity: CalculateEntity) -> String {
        entity.date?.description ?? ""
    }
    
    override func entityAccessorKey(_ object: Calculation) -> String {
        object.date.description
    }
    
}
