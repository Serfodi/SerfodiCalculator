//
//  HistoryCell.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.01.2024.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    static let reuseId = "historyCell"
    
    private var example: String = ""
    
    func config(example: String) {
        self.example = example
        self.label.text = example
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        example = ""
    }
    
}
