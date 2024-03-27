//
//  ParametersListTableViewDelegate.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 26.03.2024.
//

import UIKit

class ParametersListTableViewDelegate: NSObject { }

extension ParametersListTableViewDelegate: UITableViewDelegate {
    
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
