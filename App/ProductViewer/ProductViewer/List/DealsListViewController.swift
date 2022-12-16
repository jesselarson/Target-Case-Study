//
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit
import Kingfisher

final class DealsListViewController: UIViewController {
    
    /// View model representing the deals objects
    private var dealsListViewModel = ProductListViewModel()
    
    /// State object representing the current view state of the controller
    private var viewState: ViewState = .loading {
        didSet {
            switch viewState {
                case .loading:
                    view.addAndPinSubview(loadingView)
                    loadingView.startAnimating()
                    errorView.removeFromSuperview()
                    collectionView.refreshControl?.endRefreshing()
                    
                case .error:
                    view.addAndPinSubview(errorView)
                    loadingView.stopAnimating()
                    loadingView.removeFromSuperview()
                    collectionView.refreshControl?.endRefreshing()
                    
                case .content:
                    loadingView.stopAnimating()
                    loadingView.removeFromSuperview()
                    errorView.removeFromSuperview()
                    collectionView.refreshControl?.endRefreshing()
            }
        }
    }

    /// LoadingView instance. Set `viewState = .loading` to show
    private let loadingView = LoadingView()

    /// ErrorView instance. Set `viewState = .error` to show a default error.
    /// Set `errorView.errorType` to display a specific error message.
    private let errorView = ErrorView()

    /// The composable layout object that drives the configuration of the collection view
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
    
    /// The collection view that backs the list of deals displayed to the user
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
        collectionView.contentInset = .zero
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchDeals), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        collectionView.register(
            DealsListItemViewCell.self,
            forCellWithReuseIdentifier: DealsListItemViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        
        view.addAndPinSubview(collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Deals"
        navigationItem.backButtonDisplayMode = .minimal

        // Set the viewState to loading to present an activity indicator
        // and kick off a request to retreive the deals list
        self.viewState = .loading
        fetchDeals()
    }
}

private extension DealsListViewController {
    /// Asks the view model to retrieve the full set of deals from the server
    /// If a successful response, the collection view is reloaded to show the new deals
    /// If a failed response, an error screen is shown
    @objc private func fetchDeals() {
        Task {
            do {
                try await dealsListViewModel.fetchDeals()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.viewState = .content
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorView.setError(.unknown)
                    self.viewState = .error
                }
            }
        }
    }
}

extension DealsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let productViewModel = dealsListViewModel.productAtIndex(indexPath.row) else {
            return
        }
        
        let detailViewController = ProductDetailViewController(viewModel: productViewModel)
        show(detailViewController, sender: self)
    }
}

extension DealsListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dealsListViewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dealsListViewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let productViewModel = dealsListViewModel.productAtIndex(indexPath.row),
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DealsListItemViewCell.reuseIdentifier,
                for: indexPath
            ) as? DealsListItemViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.listItemView.configure(for: productViewModel, hideSeparator: (indexPath.row == 0))
        
        return cell
    }
}

private extension DealsListItemView {
    /// Maps the product view model data onto the list cell used to display the deal for that product.
    /// - parameter productViewModel: The view model for the product we want to display
    /// - parameter hideSeparator: A boolean that controls if a separator view is shown at the top of the cell
    func configure(for productViewModel: ProductViewModel, hideSeparator: Bool = false) {
        
        let placeholderImage = UIImage(named: "placeholder")
        let processor = DownsamplingImageProcessor(size: CGSize(width: 140, height: 140)) |> RoundCornerImageProcessor(cornerRadius: 8)
        productImage.kf.setImage(
            with: productViewModel.imageUrl,
            placeholder: placeholderImage,
            options: [.processor(processor)])
        
        separator.isHidden = hideSeparator
        
        salePriceLabel.text = productViewModel.salePriceDisplayString
        regularPriceLabel.text = productViewModel.regularPriceDisplayString
        fulfillmentLabel.text = productViewModel.fulfillment
        titleLabel.text = productViewModel.title
        availabiiltyLabel.text = productViewModel.availabilityDisplayString
        aisleLabel.text = productViewModel.aisleDisplayString
    }
}
