//
//  HistoryCalculationBox.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 17.04.2024.
//

import Foundation

public final class CalculationBox: NSObject {
    
    let unbox: Calculation
    
    init(_ value: Calculation) {
        self.unbox = value
    }
}

extension Calculation {
    var boxed: CalculationBox {
        return CalculationBox(self)
    }
}

extension CalculationBox: NSSecureCoding {
    
    public static var supportsSecureCoding: Bool { true }
    
    convenience public init?(coder: NSCoder) {
        if let data = coder.decodeObject(of: NSData.self, forKey: "unbox") {
            do {
                let decoder = JSONDecoder()
                let b = try decoder.decode(
                    Calculation.self,
                    from: (data as Data)
                )
                self.init(b)
                
            } catch let codableError {
                print(codableError)
                return nil
            }
        } else {
            return nil
        }
    }
    
    public func encode(with coder: NSCoder) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(unbox)
            coder.encode(data, forKey: "unbox")
            
        } catch let codableError {
            print(codableError)
        }
    }
}
