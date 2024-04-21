//
//  HistoryCellLayoutCalculator.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.04.2024.
//

import UIKit

protocol HistoryCellSizes {
    var totalHeight: CGFloat { get }
}

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(calculate: HistoryCalculation) -> HistoryCellSizes
}

final class HistoryCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    struct Sizes: HistoryCellSizes {
        var totalHeight: CGFloat
    }
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
    }
    
    func sizes(calculate: HistoryCalculation) -> HistoryCellSizes {
        return Sizes(totalHeight: 60)
    }
}
