//
//  SimulationViewController.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 26.03.2024.
//

import UIKit

class SimulationViewController: UIViewController {
    
    enum Layout: Int {
        case threeItemsInRow = 3
        case fourItemsInRow = 4
        case fiveItemsInRow = 5
    }
    
    // MARK: - Properties
    var infectedPeopleCountLabel = UILabel()
    var collectionView: UICollectionView!
    
    var layout: [Layout: UICollectionViewLayout] = [:]
    var activeLayout: Layout = .threeItemsInRow {
        didSet {
            if let layout = layout[activeLayout] {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }
                    self.updatePositions()
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
                        self.collectionView.setCollectionViewLayout(layout, animated: true)
                    }
                }
                
            }
        }
    }
    var groupSizeCount: Int!
    var infectionFactorCount: Int!
    var timeCount: Int!
    
    var people: [Person] = []
    var infectedPeople: [Person] = [] {
        didSet {
            infectedPeopleCountLabel.text = "Заражены: \(infectedPeople.count) человек"
        }
    }
    
    var timer: Timer!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPeople()
        setupUI()
        generateLayouts()
        configureColletionView()
        
        timer = Timer.scheduledTimer(withTimeInterval: Double(timeCount), repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.infectNeighbours()
                
                DispatchQueue.main.async {
                    self.reloadInfectedCells()
                }
            }
        })
    }
    
    deinit {
        print("SimulationViewController deinited")
    }
    
    func presentAC() {
        let ac = UIAlertController(title: "Все заражены", message: "Ты доволен?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Начать заново!", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        
        present(ac, animated: true)
    }

    func reloadInfectedCells() {
        let visibleElementsIndexPaths = collectionView.indexPathsForVisibleItems
        let infectedItemsIndexPaths = visibleElementsIndexPaths.filter({ people[$0.row].isInfected })
        collectionView.reloadItems(at: infectedItemsIndexPaths)
    }
    
    private func loadPeople() {
        var column: Int = 0
        var row: Int = 0
        
        for _ in 0..<groupSizeCount {
            people.append(Person(row: row, column: column, isInfected: false))
            column += 1
            
            if column / activeLayout.rawValue == 1 {
                row += 1
                column = 0
            }
        }
    }
    private func updatePositions() {
        var column: Int = 0
        var row: Int = 0
        
        for i in 0..<groupSizeCount {
            people[i].updatePosition(withRow: row, column: column)
            
            column += 1
            
            if column / activeLayout.rawValue == 1 {
                row += 1
                column = 0
            }
        }
     }
    
    private func personNeighbours(_ person: Person) -> [Person]? {
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
    
    private func infectNeighbours() {
        guard var infectionFactor = infectionFactorCount else {
            fatalError()
        }
        
        infectedPeople.forEach { [weak self] infectedPerson in
            guard let self = self else {
                fatalError()
            }
            guard let infectedPersonNeighbours = self.personNeighbours(infectedPerson) else { return }
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
                    self.people[index].isInfected = true // вынес с main
                    
                    DispatchQueue.main.async {
                        if !self.infectedPeople.contains(self.people[index]) {
                            self.infectedPeople.append(self.people[index])
                            
                            if self.infectedPeople.count == self.groupSizeCount {
                                self.timer.invalidate()
                                self.presentAC()
                            }
                        }
//                            self.reloadInfectedCells()
                    }
                    
                }
            }
        }
    }
    
    // MARK: - Objc
    @objc private func popVC() {
        timer.invalidate()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func switchLayout() {
        switch activeLayout {
        case .threeItemsInRow: activeLayout = .fourItemsInRow
        case .fourItemsInRow: activeLayout = .fiveItemsInRow
        case .fiveItemsInRow: activeLayout = .threeItemsInRow
        }
    }
    
    //MARK: - UI
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Симуляция"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Назад", style: .plain, target: self, action: #selector(popVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Масштаб", style: .plain, target: self, action: #selector(switchLayout))
        
        infectedPeopleCountLabel.text = "Заражены: \(infectedPeople.count) человек"
        view.addSubview(infectedPeopleCountLabel)
        infectedPeopleCountLabel.textAlignment = .right
        infectedPeopleCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infectedPeopleCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infectedPeopleCountLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateGridLayout(for: activeLayout))
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: infectedPeopleCountLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureColletionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PersonCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func generateLayouts() {
        layout[.threeItemsInRow] = generateGridLayout(for: Layout.threeItemsInRow)
        layout[.fourItemsInRow] = generateGridLayout(for: Layout.fourItemsInRow)
        layout[.fiveItemsInRow] = generateGridLayout(for: Layout.fiveItemsInRow)
    }
    
    private func updateCollectionView() {
        self.collectionView.reloadData()
    }
    
    private func generateGridLayout(for layout: Layout) -> UICollectionViewLayout {
        var groupHeightDimension: CGFloat
        var itemsCount: Int
        
        switch layout {
        case .threeItemsInRow:
            groupHeightDimension = 1/7
            itemsCount = 3
        case .fourItemsInRow:
            groupHeightDimension = 1/9
            itemsCount = 4
        case .fiveItemsInRow:
            groupHeightDimension = 1/11
            itemsCount = 5
        }
        
        let padding: CGFloat = 15
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(groupHeightDimension)
            ),
            subitem: item,
            count: itemsCount
        )
        group.interItemSpacing = .fixed(padding)
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: padding,
            bottom: 0,
            trailing: padding
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = padding
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: padding,
            leading: 0,
            bottom: padding,
            trailing: 0
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    
    
}

extension SimulationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        let item = people[indexPath.item]
        print("Строка: \(item.row), Колонка: \(item.column)")
        
        people[indexPath.row].isInfected = true
        
        if !infectedPeople.contains(people[indexPath.row]) {
            infectedPeople.append(people[indexPath.row])
            
            if infectedPeople.count == groupSizeCount {
                timer.invalidate()
                presentAC()
            }
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
