//
//  SimulationParametersViewController.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 25.03.2024.
//

import UIKit

enum Section: Int, CaseIterable {
    case groupSize
    case infectionFactor
    case time
}

class SimulationParametersViewController: UIViewController {
    
    // MARK: - Properties
    let subtitleLabel = UILabel()
    
    let groupSizeLabel = UILabel()
    var groupSizeCountLabel = UILabel()
    var groupSizeSlider = UISlider()
    
    let infectionFactorLabel = UILabel()
    var infectionFactorCountLabel = UILabel()
    var infectionFactorSlider = UISlider()
    
    let timeLabel = UILabel()
    var timeCountLabel = UILabel()
    var timeSlider = UISlider()
    
    let startSimulationButton = UIButton()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Objc
    @objc private func groupSizeSliderValueChanged() {
        groupSizeCountLabel.text = "\(Int(groupSizeSlider.value))"
}
    
    @objc private func infectionFactorSliderValueChanged() {
        infectionFactorCountLabel.text = "\(Int(infectionFactorSlider.value))"
}
    
    @objc private func timeSliderValueChanged() {
        timeCountLabel.text = "\(Int(timeSlider.value))"
}
    
    @objc private func startSimulation() {
        let simulationVC = SimulationViewController()
        
        simulationVC.groupSizeCount = Int(groupSizeSlider.value)
        simulationVC.infectionFactorCount = Int(infectionFactorSlider.value)
        simulationVC.timeCount = Int(timeSlider.value)
        
        navigationController?.pushViewController(simulationVC, animated: true)
    }
    
    // MARK: - UI
    private func setupUI() {
        setupBaseUI()
        configureSliders()
        configureLabels()
        configureButtons()
        setupUIConstraints()
    }
    
    private func setupBaseUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Инфицирование"
    }
    
    private func configureSliders() {
        groupSizeSlider.thumbTintColor = UIColor(red: 0, green: 0.47, blue: 1, alpha: 1)
        groupSizeSlider.minimumValueImage = UIImage(systemName: "minus")
        groupSizeSlider.maximumValueImage = UIImage(systemName: "plus")
        groupSizeSlider.addTarget(self, action: #selector(groupSizeSliderValueChanged), for: .valueChanged)
        groupSizeSlider.minimumValue = 27
        groupSizeSlider.maximumValue = 900
        
        infectionFactorSlider.thumbTintColor = UIColor(red: 0, green: 0.47, blue: 1, alpha: 1)
        infectionFactorSlider.minimumValueImage = UIImage(systemName: "minus")
        infectionFactorSlider.maximumValueImage = UIImage(systemName: "plus")
        infectionFactorSlider.addTarget(self, action: #selector(infectionFactorSliderValueChanged), for: .valueChanged)
        infectionFactorSlider.minimumValue = 1
        infectionFactorSlider.maximumValue = 8
        
        timeSlider.thumbTintColor = UIColor(red: 0, green: 0.47, blue: 1, alpha: 1)
        timeSlider.minimumValueImage = UIImage(systemName: "minus")
        timeSlider.maximumValueImage = UIImage(systemName: "plus")
        timeSlider.addTarget(self, action: #selector(timeSliderValueChanged), for: .valueChanged)
        timeSlider.minimumValue = 1
        timeSlider.maximumValue = 5
    }
    
    private func configureLabels() {
        subtitleLabel.text = "Выберите параметры симуляции"
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        groupSizeLabel.text = "Количество людей в моделируемой группе:"
        groupSizeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        groupSizeCountLabel.text = "\(Int(groupSizeSlider.value))"
        
        infectionFactorLabel.text = "Количество людей, которое может быть заражено одним человеком при контакте:"
        infectionFactorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        infectionFactorLabel.numberOfLines = 0
        
        infectionFactorCountLabel.text = "\(Int(infectionFactorSlider.value))"
        
        timeLabel.text = "Период пересчета количества зараженных людей в секундах:"
        timeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        timeLabel.numberOfLines = 0
        
        timeCountLabel.text = "\(Int(timeSlider.value))"
    }
    
    
    
    private func configureButtons() {
        startSimulationButton.backgroundColor = UIColor(red: 0, green: 0.47, blue: 1, alpha: 1)
        startSimulationButton.setTitle("Запустить моделирование", for: .normal)
        startSimulationButton.setTitleColor(.white, for: .normal)
        startSimulationButton.layer.cornerRadius = CGFloat(25)
        startSimulationButton.addTarget(self, action: #selector(startSimulation), for: .touchUpInside)
    }
    
    private func setupUIConstraints() {
        view.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             subtitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
             subtitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ]
        )
        view.addSubview(groupSizeLabel)
        groupSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [groupSizeLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
             groupSizeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
             groupSizeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ]
        )
        view.addSubview(groupSizeCountLabel)
        groupSizeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [groupSizeCountLabel.topAnchor.constraint(equalTo: groupSizeLabel.bottomAnchor, constant: 10),
             groupSizeCountLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ]
        )
        view.addSubview(groupSizeSlider)
        groupSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [groupSizeSlider.topAnchor.constraint(equalTo: groupSizeCountLabel.bottomAnchor, constant: 0),
             groupSizeSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
             groupSizeSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
            ]
        )
        view.addSubview(infectionFactorLabel)
        infectionFactorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [infectionFactorLabel.topAnchor.constraint(equalTo: groupSizeSlider.bottomAnchor, constant: 50),
             infectionFactorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
             infectionFactorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ]
        )
        view.addSubview(infectionFactorCountLabel)
        infectionFactorCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [infectionFactorCountLabel.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor, constant: 10),
             infectionFactorCountLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ]
        )
        view.addSubview(infectionFactorSlider)
        infectionFactorSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [infectionFactorSlider.topAnchor.constraint(equalTo: infectionFactorCountLabel.bottomAnchor, constant: 0),
             infectionFactorSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
             infectionFactorSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
            ]
        )
        view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [timeLabel.topAnchor.constraint(equalTo: infectionFactorSlider.bottomAnchor, constant: 50),
             timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
             timeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ]
        )
        view.addSubview(timeCountLabel)
        timeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [timeCountLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
             timeCountLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ]
        )
        view.addSubview(timeSlider)
        timeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [timeSlider.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
             timeSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
             timeSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
            ]
        )
        view.addSubview(startSimulationButton)
        startSimulationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [startSimulationButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
             startSimulationButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
             startSimulationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
             startSimulationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
             startSimulationButton.heightAnchor.constraint(equalToConstant: 75)
            ]
        )
    }
}

