//
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit
import Kingfisher

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
        
        collectionView.backgroundColor = UIColor.white
        
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
        
        fetchDeals()
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
        
        cell.listItemView.configure(for: product, hideSeparator: (indexPath.row == 0))
        
        return cell
    }
}

// TODO: weak self here?
private extension StandaloneListViewController {
    @objc private func fetchDeals() {
        APIClient().retrieveDeals { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let products):
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

// TODO: Why is this in the Controller?
// TODO: Fix hardcoded width/height values
private extension StandaloneListItemView {
    func configure(for productViewModel: ProductViewModel, hideSeparator: Bool = false) {
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 140, height: 140)) |> RoundCornerImageProcessor(cornerRadius: 20)
        productImage.kf.setImage(with: productViewModel.imageUrl, options: [.processor(processor)])
        
        separator.isHidden = hideSeparator
        
        salePriceLabel.text = productViewModel.salePriceDisplayString
        regularPriceLabel.text = productViewModel.regularPriceDisplayString
        fulfillmentLabel.text = productViewModel.fulfillment
        titleLabel.text = productViewModel.title
        availabiiltyLabel.text = productViewModel.availabilityDisplayString
        aisleLabel.text = productViewModel.aisleDisplayString
    }
}
