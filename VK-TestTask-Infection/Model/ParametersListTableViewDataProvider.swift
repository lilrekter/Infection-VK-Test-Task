//
//  ParametersListDataProvider.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 25.03.2024.
//

import UIKit

class ParametersListTableViewDataProvider: NSObject { }

extension ParametersListTableViewDataProvider: UITableViewDataSource {
    
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
}
