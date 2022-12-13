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
    private let productViewModel: ProductViewModel
    
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

    private let loadingView = LoadingView()

    private let errorView = ErrorView()
    
    private let addToCartView = AddToCartView()
    
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
    func fetchDetails() {
        productViewModel.fetchProductDetail(onSuccess: { [weak self] in
            
            // On success, reload the collection view to display the latest content
            //     and set the viewState to content to clear any loading or error screens
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.viewState = .content
            }
        }, onError: { [weak self] error in
            
            // On error, show a specific error message for a 404 response with an ITEM_NOT_FOUND code in the reponse body
            DispatchQueue.main.async {
                var errorType: ErrorType = .unknown
                
                if let apiError = error as? APIClientError {
                    switch apiError {
                        case .unsuccessfulResponse(404, "ITEM_NOT_FOUND", _):
                            errorType = .itemNotFound
                        case .badUrl, .parsing(_), .unsuccessfulResponse(_, _, _), .unknown:
                            errorType = .unknown
                    }
                }
                
                self?.errorView.setError(errorType)
                self?.viewState = .error
            }
        })
    }
}

extension ProductDetailViewController {
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
    func configure(for viewModel: ProductViewModel) {
        productImage.kf.setImage(with: viewModel.imageUrl)
        titleLabel.text = viewModel.title
        salePriceLabel.text = viewModel.salePriceDisplayString
        regularPriceLabel.text = viewModel.regularPriceDisplayString
        fulfillmentLabel.text = viewModel.fulfillment
    }
}

private extension ProductDescriptionItemView {
    func configure(for viewModel: ProductViewModel) {
        descriptionLabel.text = viewModel.descripition
    }
}
