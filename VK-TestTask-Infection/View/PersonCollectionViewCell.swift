//
//  PersonCollectionViewCell.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 27.03.2024.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "PersonCell"
    
    var cellColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = cellColor
    }
}
