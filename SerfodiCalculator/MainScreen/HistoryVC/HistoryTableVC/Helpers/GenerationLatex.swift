//
//  GenerationLatex.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 08.04.2024.
//

import Foundation

final class GenerationLatex {
    
    /// Создает математический пример в виде Latex формулы
    func generate(expression: Calculation, formatting: (NSNumber)->(String)) -> String {
        let expressionPost = CalculationItemParser().parsing(items: expression.expression)
        
        var result: [String] = []
        for item in expressionPost {
            switch item {
            case .number(let number):
                result.append(formatting(number as NSNumber))
            case .operation(let sign):
                guard let numbers = result.pop(sign.type.rawValue) else { break }
                result.append(sign.generateLatex(numbers))
            }
        }
        result.append(" =" + formatting(expression.result as NSNumber))
        return result.joined()
    }
}

extension Operation {
    func generateLatex(_ op: [String]) -> String {
        switch self {
        case .add:
            return "{\(op[0])} + {\(op[1])}"
        case .subtract:
            return "{\(op[0])} - {\(op[1])}"
        case .multiply:
            return "{\(op[0])}" + #"\times"# + "{\(op[1])}"
        case .divide:
            return "{\(op[0])}" + #"\div"# + "{\(op[1])}"
        case .precent:
            return "{\(op[0])}%"
        case .pow2:
            return "{\(op[0])}^{2}"
        case .pow3:
            return "{\(op[0])}^{3}"
        case .powXY:
            return "{\(op[0])}^{\(op[1])}"
        case .powYX:
            return "{\(op[1])}^{\(op[0])}"
        case .powEX:
            return "{e}^{\(op[0])}"
        case .pow10X:
            return "{10}^{\(op[0])}"
        case .pow2X:
            return "{2}^{\(op[0])}"
        case .divisionByOne:
            return #"\frac{1}"# + "{\(op[0])}"
        case .root2:
            return #"\sqrt"# + "{\(op[0])}"
        case .root3:
            return #"\sqrt[3]"# + "{\(op[0])}"
        case .rootYX:
            return #"\sqrt"# + "[\(op[1])]" + "{\(op[0])}"
        case .lnX:
            return "ln" + "{\(op[0])}"
        case .log10X:
            return #"\log_10"# + "{\(op[0])}"
        case .logY:
            return #"\log_"# + "{\(op[1])}" + "{\(op[0])}"
        case .log2X:
            return #"\log_2"# + "{\(op[0])}"
        case .factorial:
            return "{\(op[0])}" + "!"
        case .sinX:
            return #"\sin"# + "{\(op[0])}"
        case .cosX:
            return #"\cos"# + "{\(op[0])}"
        case .tanX:
            return #"\tanh"# + "{\(op[0])}"
        case .sinhX:
            return #"\sinh"# + "{\(op[0])}"
        case .coshX:
            return #"\cosh"# + "{\(op[0])}"
        case .tanhX:
            return #"\tanh"# + "{\(op[0])}"
        }
    }
}
