//
//  ProductDetailViewController.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/12/22.
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit
import Kingfisher

final class ProductDetailViewController: UIViewController {
    /// View model representing the product being displayed
    private let productViewModel: ProductViewModel
    
    /// State object representing the current view state of the controller
    private var viewState: ViewState = .loading {
        didSet {
            switch viewState {
                case .loading:
                    view.addAndPinSubview(loadingView)
                    loadingView.startAnimating()
                    errorView.removeFromSuperview()
                case .error:
                    view.addAndPinSubview(errorView)
                    loadingView.stopAnimating()
                    loadingView.removeFromSuperview()
                case .content:
                    loadingView.stopAnimating()
                    loadingView.removeFromSuperview()
                    errorView.removeFromSuperview()
            }
        }
    }

    /// LoadingView instance. Set `viewState = .loading` to show
    private let loadingView = LoadingView()

    /// ErrorView instance. Set `viewState = .error` to show a default error.
    /// Set `errorView.errorType` to display a specific error message.
    private let errorView = ErrorView()
    
    // AddToCartView overlay instance. Set the `action` property of the view
    // to perform an action when the view's button is tapped
    private let addToCartView = AddToCartView()
    
    /// The collection view that backs the detail view sections
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        
        collectionView.backgroundColor = UIColor.background
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        
        collectionView.register(
            ProductSummaryCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductSummaryCollectionViewCell.reuseIdentifier
        )
        
        collectionView.register(
            ProductDescriptionCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductDescriptionCollectionViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    // Require this viewController to be initialized with a view model
    init(viewModel: ProductViewModel) {
        self.productViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("NSCoder is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        navigationItem.backButtonDisplayMode = .minimal
        
        view.backgroundColor = UIColor.background
        view.addSubview(collectionView)
        view.addSubview(addToCartView)
        
        // Add height to the Add to cart button overlay to account for devices with the home indicator
        var height = 76.0
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        
        if let window = window {
            let bottomInset = window.safeAreaInsets.bottom
            height += bottomInset
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addToCartView.topAnchor),
            
            addToCartView.heightAnchor.constraint(equalToConstant: height),
            addToCartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addToCartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addToCartView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        addToCartView.action = { [weak self] in
            guard let self = self else { return }
            self.performAddToCartAction()
        }

        collectionView.contentInset = .zero
        
        // Finally, set the viewState to loading and kick off a request to retreive the product detail
        viewState = .loading
        fetchDetails()
    }
    
}

extension ProductDetailViewController {
    /// Asks the product view model to retrieve the detail object for the product. This call returns
    /// more description data than the value returned on the deals list response.
    ///
    /// If a successful response, the collection view is reloaded to show the updated product details
    /// If a failed response for an item not found, a specific error message is show. Otherwise, a generic
    /// error is displayed.
    func fetchDetails() {
        Task {
            await  productViewModel.fetchProductDetail(onSuccess: { [weak self] in
                
                // On success, reload the collection view to display the latest content
                //     and set the viewState to content to clear any loading or error screens
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.viewState = .content
                }
            }, onError: { [weak self] error in
                
                // On error, show the appropriate message based upon the error returned
                DispatchQueue.main.async {
                    var errorType: ErrorType = .unknown
                    
                    if let apiError = error as? DealsServiceError {
                        switch apiError {
                            case .itemNotFound:
                                errorType = .itemNotFound
                            case .unknown, .parsing(_):
                                errorType = .unknown
                        }
                    }
                    
                    self?.errorView.setError(errorType)
                    self?.viewState = .error
                }
            })
        }
    }
}

extension ProductDetailViewController {
    /// Closure representing the action desired when the user taps the Add to cart button
    func performAddToCartAction() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Item added to your cart!",
                message: "\(self.productViewModel.title) has been added to your cart.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil) )
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ProductDetailViewController {
    /// Creates the collection view layout using the sectionProvider pattern.
    ///
    /// Sections are described by the `DetailSectionConfiguration` enum
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionConfig = DetailSectionConfiguration(rawValue: sectionIndex) else { return nil }
            
            let esimatedHeight = sectionConfig.estimatedHeight
            
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(esimatedHeight)
            )
            
            let item = NSCollectionLayoutItem(
                layoutSize: layoutSize
            )
            
            item.edgeSpacing = .init(
                leading: nil,
                top: nil,
                trailing: nil,
                bottom: nil
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                subitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(
                group: group
            )
            
            section.contentInsets = sectionConfig.contentInsets
            return section
        }
        
        return layout
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DetailSectionConfiguration.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionConfig = DetailSectionConfiguration(rawValue: section) else { return 0 }
        
        return sectionConfig.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionConfig = DetailSectionConfiguration(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        var cell: UICollectionViewCell
        switch sectionConfig {
            case .summary:
                cell = configureProductSummaryCell(for: indexPath)
            case .description:
                cell = configureProductDescriptionCell(for: indexPath)
        }
        
        return cell
    }
}

extension ProductDetailViewController {
    /// Dequeues a `ProductSummaryCollectionViewCell` and calls the `configure` method associated with it
    /// - parameter indexPath: The `indexPath` of the collection view item we will be displaying
    func configureProductSummaryCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductSummaryCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? ProductSummaryCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.itemView.configure(for: productViewModel)
        return cell
    }
    
    /// Dequeues a `ProductDescriptionCollectionViewCell` and calls the `configure` method associated with it
    /// - parameter indexPath: The `indexPath` of the collection view item we will be displaying
    func configureProductDescriptionCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductDescriptionCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? ProductDescriptionCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.itemView.configure(for: productViewModel)
        return cell
    }
}

private extension ProductSummaryItemView {
    /// Maps the product view model data onto the list cell used to display the summary section details
    /// - parameter productViewModel: The view model for the product we want to display
    func configure(for viewModel: ProductViewModel) {
        productImage.kf.setImage(with: viewModel.imageUrl)
        titleLabel.text = viewModel.title
        salePriceLabel.text = viewModel.salePriceDisplayString
        regularPriceLabel.text = viewModel.regularPriceDisplayString
        fulfillmentLabel.text = viewModel.fulfillment
    }
}

private extension ProductDescriptionItemView {
    /// Maps the product view model data onto the list cell used to display the description section details
    /// - parameter productViewModel: The view model for the product we want to display
    func configure(for viewModel: ProductViewModel) {
        descriptionLabel.text = viewModel.descripition
    }
}
