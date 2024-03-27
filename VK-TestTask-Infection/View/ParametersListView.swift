//
//  ParametersListView.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 26.03.2024.
//

import UIKit

class ParametersListView: UIView {
    let subtitleLabel = UILabel()
    
    let groupSizeLabel = UILabel()
    let groupSizeSlider = UISlider()
    
    let infectionFactorLabel = UILabel()
    let infectionFactorSlider = UISlider()
    
    let timeLabel = UILabel()
    let timeSlider = UISlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabels()
        configureSliders()
        setupUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabels() {
        subtitleLabel.text = "Выберите параметры симуляции"
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        groupSizeLabel.text = "Количество людей в моделируемой группе"
        groupSizeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        infectionFactorLabel.text = "Количество людей, которое может быть заражено одним человеком при контакте"
        infectionFactorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        infectionFactorLabel.numberOfLines = 0
        
        timeLabel.text = "Период пересчета количества зараженных людей."
        timeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
    
    private func configureSliders() {
        
    }
    
    private func setupUIConstraints() {
        self.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [subtitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
             subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
             subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
             ]
        )
        self.addSubview(groupSizeLabel)
        groupSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [groupSizeLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
             groupSizeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
             groupSizeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
             ]
        )
        self.addSubview(groupSizeSlider)
        groupSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [groupSizeSlider.topAnchor.constraint(equalTo: groupSizeLabel.bottomAnchor, constant: 30),
             groupSizeSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             groupSizeSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor)
             ]
        )
        self.addSubview(infectionFactorLabel)
        infectionFactorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [infectionFactorLabel.topAnchor.constraint(equalTo: groupSizeSlider.bottomAnchor, constant: 30),
             infectionFactorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
             infectionFactorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
             ]
        )
        self.addSubview(infectionFactorSlider)
        infectionFactorSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [infectionFactorSlider.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor, constant: 30),
             infectionFactorSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             infectionFactorSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor)
             ]
        )
        self.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [timeLabel.topAnchor.constraint(equalTo: infectionFactorSlider.bottomAnchor, constant: 30),
             timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
             timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
             ]
        )
        self.addSubview(timeSlider)
        timeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [timeSlider.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
             timeSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             timeSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor)
             ]
        )
    }
}
