//
//  LabelScrollView.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.04.2024.
//

import UIKit

class ContentScrollView: UIScrollView {
    
    private var contentView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollsToTop = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addView(_ view: UIView) {
        contentView.addSubview(view)
        labelLayoutConfiguration(view)
    }
    
    private func configuration() {
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor),
        ])
    }
    
    private func labelLayoutConfiguration(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 2),
            view.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -2)
        ])
    }
}
