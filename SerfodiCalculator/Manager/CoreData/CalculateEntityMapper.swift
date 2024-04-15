//
//  CalculateEntityMapper.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.04.2024.
//

import CoreData

final class CalculateEntityMapper: EntityMapper<Calculation, CalculateEntity> {
    
    override func update(_ entity: CalculateEntity, by model: Calculation) {
        entity.result = model.result
        entity.date = Date()
    }
    
}
