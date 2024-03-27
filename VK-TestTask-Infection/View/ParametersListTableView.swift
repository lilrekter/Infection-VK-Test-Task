//
//  ParametersListTableView.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 26.03.2024.
//

import UIKit

class ParametersListTableView: UITableView {
    
    func add(on view: UIView) {
        view.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             self.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
             self.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
             self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        )
    }
}


