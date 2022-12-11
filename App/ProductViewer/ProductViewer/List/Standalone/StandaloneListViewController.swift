//
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit

final class StandaloneListViewController: UIViewController {
    private var dealsListViewModel: ProductListViewModel?
    
    private lazy var layout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(172)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        
        item.edgeSpacing = .init(
            leading: nil,
            top: nil,
            trailing: nil,
            bottom: .fixed(2)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(172)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(
            group: group
        )
        
        let layout = UICollectionViewCompositionalLayout(
            section: section
        )
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.backgroundColor = UIColor.background
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchDeals), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        
        collectionView.register(
            StandaloneListItemViewCell.self,
            forCellWithReuseIdentifier: StandaloneListItemViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    private var sections: [ListSection] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)

        collectionView.contentInset = .zero
        
        title = "List"
        
        view.addAndPinSubview(collectionView)
        
        sections = [
            ListSection(
                index: 1,
                items: (1..<10).map { index in
                    ListItem(
                        title: "Puppies!!!",
                        price: "$9.99",
                        image: UIImage(named: "\(index)"),
                        index: index
                    )
                }
            ),
        ]
        
        // fetchDeals()
    }
}

extension StandaloneListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            sections.indices.contains(indexPath.section),
            sections[indexPath.section].items.indices.contains(indexPath.row)
        else {
            return
        }
        
        let productListItem = sections[indexPath.section].items[indexPath.row]
        
        let alert = UIAlertController(
            title: "Item \(productListItem.index) selected!",
            message: "🐶",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil) )
        
        present(alert, animated: true, completion: nil)
    }
}

extension StandaloneListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let dealsListViewModel = dealsListViewModel else { return 0 }
        
        return dealsListViewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dealsListViewModel = dealsListViewModel else { return 0 }
        
        return dealsListViewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let product = dealsListViewModel?.productAtIndex(indexPath),
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StandaloneListItemViewCell.reuseIdentifier,
                for: indexPath
            ) as? StandaloneListItemViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.listItemView.configure(for: product)
        
        return cell
    }
}

private extension StandaloneListViewController {
    @objc private func fetchDeals() {
        APIClient().retrieveDeals { result in
            switch result {
                case .success(let products):
                    print(products)
                    self.dealsListViewModel = ProductListViewModel(products: products)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.collectionView.refreshControl?.endRefreshing()
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.collectionView.refreshControl?.endRefreshing()
                    }
            }
        }
    }
}

private extension StandaloneListItemView {
    func configure(for productViewModel: ProductViewModel) {
        salePriceLabel.text = productViewModel.salePriceDisplayString
        regularPriceLabel.text = productViewModel.regularPriceDisplayString
        fulfillmentLabel.text = productViewModel.fulfillment
        titleLabel.text = productViewModel.title
        availabiiltyLabel.text = productViewModel.availabilityDisplayString
    }
}
