//
//  HistoryCalculationTransformer.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 17.04.2024.
//

import Foundation

final class CalculationTransformer: NSSecureUnarchiveFromDataTransformer {
    
    static let name = NSValueTransformerName(
        rawValue: String(describing: CalculationTransformer.self)
    )
    
    public static func register() {
        let transformer = CalculationTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [CalculationBox.self, NSData.self]
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let calculation = try NSKeyedUnarchiver.unarchivedObject(
                ofClass: CalculationBox.self,
                from: data)
            return calculation
        } catch {
            print(error)
            return nil
        }
    }
    
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let box = value as? CalculationBox else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: box, requiringSecureCoding: true)
            return data
        } catch {
            print(error)
            return nil
        }
    }
}
