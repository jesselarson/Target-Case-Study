//
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit
import Kingfisher

final class StandaloneListViewController: UIViewController {
    private var dealsListViewModel = ProductListViewModel()
    
    private lazy var layout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
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
        
        navigationItem.backButtonDisplayMode = .minimal
        
        view.addAndPinSubview(collectionView)

        collectionView.contentInset = .zero
        
        title = "Deals"
        
        fetchDeals()
    }
}

extension StandaloneListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let productViewModel = dealsListViewModel.productAtIndex(indexPath) else {
            return
        }
        
        productViewModel.fetchProductDetail {
            print("fetchProductDetail onSuccess")
        } onError: { error in
            print("fetchProductDetail onError")
        }
        
        let detailViewController = ProductDetailViewController(viewModel: productViewModel)
        show(detailViewController, sender: self)
    }
}

extension StandaloneListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dealsListViewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dealsListViewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let productViewModel = dealsListViewModel.productAtIndex(indexPath),
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StandaloneListItemViewCell.reuseIdentifier,
                for: indexPath
            ) as? StandaloneListItemViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.listItemView.configure(for: productViewModel, hideSeparator: (indexPath.row == 0))
        
        return cell
    }
}

private extension StandaloneListViewController {
    @objc private func fetchDeals() {
        dealsListViewModel.fetchDeals(onSuccess: { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }, onError: { error in
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
            }
        })
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
