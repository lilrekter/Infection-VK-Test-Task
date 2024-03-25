//
//  SimulationParametersViewController.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 25.03.2024.
//

import UIKit

class SimulationParametersViewController: UIViewController {
    
    // MARK: - Properties
    
    var parametersListTableView = UITableView()
    var parametersListDataProvider = ParametersListDataProvider()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupUI()
    }
    
    func configureTableView() {
        parametersListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestCell")
        parametersListTableView.dataSource = parametersListDataProvider
        parametersListTableView.delegate = parametersListDataProvider
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Введите параметры симуляции"
        
        view.addSubview(parametersListTableView)
        
        parametersListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [parametersListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
             parametersListTableView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
             parametersListTableView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
             parametersListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)]
        )
    }
}

