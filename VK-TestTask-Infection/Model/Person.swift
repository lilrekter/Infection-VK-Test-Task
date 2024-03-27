//
//  Person.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 26.03.2024.
//

import Foundation

struct Person: Hashable, Equatable {
    var row: Int
    var column: Int
    var isInfected: Bool
    
    mutating func updatePosition(withRow row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return (lhs.row == rhs.row && lhs.column == rhs.column && lhs.isInfected == rhs.isInfected)
    }
}
