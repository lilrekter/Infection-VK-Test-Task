//
//  SimulationCollectionViewDataProvider.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 27.03.2024.
//

import UIKit

protocol DataProviderDelegate: AnyObject {
    var activeLayout: Layout { get set }
    
    func updateLabels()
    func invalidateTimer()
    func presentAC()
    func reloadInfectedCells()
}

class SimulationCollectionViewDataProvider: NSObject {
    
    deinit {
        print("SimulationCollectionViewDataProvider deinited")
    }
    
    weak var delegate: DataProviderDelegate?
    
    var groupSizeCount: Int!
    var infectionFactorCount: Int!
    var timeCount: Int!
    
    var people: [Person] = []
    var infectedPeople: [Person] = [] {
        didSet {
            delegate?.updateLabels()
        }
    }
    
    func loadPeople() {
        var column: Int = 0
        var row: Int = 0
        
        for _ in 0..<groupSizeCount {
            people.append(Person(row: row, column: column, isInfected: false))
            column += 1
            
            if column / (delegate?.activeLayout.rawValue)! == 1 {
                row += 1
                column = 0
            }
        }
    }
    
    func personNeighbours(for person: Person) -> [Person]? {
        var neighbours: [Person] = []
        
        let rowRange = (person.row - 1)...(person.row + 1)
        let columnRange = (person.column - 1)...(person.column + 1)
        
        for c in columnRange {
            for r in rowRange {
                guard let neighbourPerson = self.people.filter( { $0.row == r && $0.column == c }).first else { continue }
                neighbours.append(neighbourPerson)
            }
        }
        guard let personToRemoveIndex = neighbours.firstIndex(of: person) else { return nil }
        neighbours.remove(at: personToRemoveIndex)
        
        return neighbours
    }
    
    func infectNeighbours() {
        guard var infectionFactor = infectionFactorCount else {
            fatalError()
        }
        
        infectedPeople.forEach { [weak self] infectedPerson in
            guard let self = self else {
                fatalError()
            }
            guard let infectedPersonNeighbours = self.personNeighbours(for: infectedPerson) else { return }
            let infectedPersonNeighboursCount = infectedPersonNeighbours.count
            
            if infectionFactor >= infectedPersonNeighboursCount {
                infectionFactor = infectedPersonNeighboursCount
            }
            
            if let infectedFactorRangeRandomNumber = (1...infectionFactor).randomElement() {
                let shuffledArray = infectedPersonNeighbours.shuffled()
                let randomPeople = shuffledArray.prefix(infectedFactorRangeRandomNumber)
                
                randomPeople.forEach { randomPerson in
                    guard let index = self.people.firstIndex(of: randomPerson) else {
                        fatalError()
                    }
                    // Здесь иногда прилетает ошибка по памяти. Не сталкивался пока с таким.
                    self.people[index].isInfected = true
                    
                    DispatchQueue.main.async {
                        if !self.infectedPeople.contains(self.people[index]) {
                            self.infectedPeople.append(self.people[index])
                            
                            if self.infectedPeople.count == self.groupSizeCount {
                                self.delegate?.invalidateTimer()
                                self.delegate?.presentAC()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension SimulationCollectionViewDataProvider: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath)
        cell.contentView.backgroundColor = people[indexPath.row].isInfected ? .red : .lightGray
        cell.contentView.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       people[indexPath.row].isInfected = true
        
        if !infectedPeople.contains(people[indexPath.row]) {
            infectedPeople.append(people[indexPath.row])
            
            if infectedPeople.count == groupSizeCount {
                delegate?.invalidateTimer()
                delegate?.presentAC()
            }
        }
        delegate?.reloadInfectedCells()
    }
}
