//
//  SimulationViewController.swift
//  VK-TestTask-Infection
//
//  Created by Vitaly on 26.03.2024.
//

import UIKit

enum Layout: Int {
    case threeItemsInRow = 3
    case fourItemsInRow = 4
    case fiveItemsInRow = 5
}

class SimulationViewController: UIViewController {
    
    // MARK: - Properties
    var dataProvider = SimulationCollectionViewDataProvider()
    
    var groupSizeCount: Int!
    var infectionFactorCount: Int!
    var timeCount: Int!
    
    private var timer: Timer!
    private var infectedPeopleCountLabel = UILabel()
    
    private var collectionView: UICollectionView!
    private var layout: [Layout: UICollectionViewLayout] = [:]
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataToDataProvider()
        dataProvider.loadPeople()
        setupUI()
        generateLayouts()
        configureColletionView()
        setupTimer()
    }
    
    deinit {
        print("SimulationViewController deinited")
    }
    
    private func loadDataToDataProvider() {
        dataProvider.delegate = self
        
        dataProvider.groupSizeCount = self.groupSizeCount
        dataProvider.infectionFactorCount = self.infectionFactorCount
        dataProvider.timeCount = self.timeCount
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: Double(timeCount), repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.dataProvider.infectNeighbours()
                
                DispatchQueue.main.async {
                    self.reloadInfectedCells()
                }
            }
        })
    }
    
    func invalidateTimer() {
        timer.invalidate()
    }
    
    private func updatePositions() {
        var column: Int = 0
        var row: Int = 0
        
        for i in 0..<groupSizeCount {
            dataProvider.people[i].updatePosition(withRow: row, column: column)
            
            column += 1
            
            if column / activeLayout.rawValue == 1 {
                row += 1
                column = 0
            }
        }
     }
    
    //MARK: - UI
    func presentAC() {
        let ac = UIAlertController(title: "Все заражены", message: "Ты доволен?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Начать заново!", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        
        present(ac, animated: true)
    }
    
    func reloadInfectedCells() {
        let visibleElementsIndexPaths = collectionView.indexPathsForVisibleItems
        let infectedItemsIndexPaths = visibleElementsIndexPaths.filter({ dataProvider.people[$0.row].isInfected })
        collectionView.reloadItems(at: infectedItemsIndexPaths)
    }
    
    func updateLabels() {
        infectedPeopleCountLabel.text = "Заражены: \(dataProvider.infectedPeople.count) человек"
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Симуляция"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Назад", style: .plain, target: self, action: #selector(popVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Масштаб", style: .plain, target: self, action: #selector(switchLayout))
        
        infectedPeopleCountLabel.text = "Заражены: \(dataProvider.infectedPeople.count) человек"
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
        collectionView.dataSource = dataProvider
        collectionView.delegate = dataProvider
    }
    
    private func generateLayouts() {
        layout[.threeItemsInRow] = generateGridLayout(for: Layout.threeItemsInRow)
        layout[.fourItemsInRow] = generateGridLayout(for: Layout.fourItemsInRow)
        layout[.fiveItemsInRow] = generateGridLayout(for: Layout.fiveItemsInRow)
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
}

extension SimulationViewController: DataProviderDelegate { }

