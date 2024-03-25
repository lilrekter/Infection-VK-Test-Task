//
//  ParametersListDataProvider.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 25.03.2024.
//

import UIKit

class ParametersListDataProvider: NSObject {
    enum Section: Int, CaseIterable {
        case groupSize
        case infectionFactor
        case time
    }
}

extension ParametersListDataProvider: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        
        let section = indexPath.section
        switch section {
        case 0: cell.textLabel?.text = "Cell 1"
        case 1: cell.textLabel?.text = "Cell 2"
        case 2: cell.textLabel?.text = "Cell 3"
        default: break
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else {
            fatalError()
        }
        
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        
        switch section {
        case .groupSize: label.text = "Количество людей в моделируемой группе"
        case .infectionFactor: label.text = "Количество людей, которое может быть заражено одним человеком"
        case .time: label.text = "Период пересчета количества зараженных людей"
        }
        return label
    }
}
