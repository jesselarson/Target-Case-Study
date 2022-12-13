//
//  ProductDetailViewController.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/12/22.
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit
import Kingfisher

enum SectionLayouts: Int, CaseIterable {
    case image
    case summary
    case description
    
    var itemCount: Int {
        switch self {
            case .image, .summary, .description:
                return 1
        }
    }
    
    var estimatedHeight: CGFloat {
        switch self {
            case .image:
                return 390.0
            case .summary:
                return 100.0
            case .description:
                return 200.0
        }
    }
}

final class ProductDetailViewController: UIViewController {
    private let productViewModel: ProductViewModel
    
    private let addToCartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        // Round the top corners
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Add a drop shadow to the top
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        
//        // Add button
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .targetRed
        button.setTitle("Add to cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .largeBold
        button.layer.cornerRadius = 8
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        
        collectionView.backgroundColor = UIColor.background
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            ProductImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductImageCollectionViewCell.reuseIdentifier
        )
        
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
        
        navigationItem.backButtonDisplayMode = .minimal
        
        view.addAndPinSubview(collectionView)
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
            addToCartView.heightAnchor.constraint(equalToConstant: height),
            addToCartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addToCartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addToCartView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.contentInset = .zero
        
        title = "Details"
        
        productViewModel.fetchProductDetail {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } onError: { error in
            DispatchQueue.main.async {
                // TODO: show error view on main thread
            }
        }
    }
    
}

extension ProductDetailViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionLayout = SectionLayouts(rawValue: sectionIndex) else { return nil }
            
            let esimatedHeight = sectionLayout.estimatedHeight
            
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
            
            return section
        }
        
        return layout
    }
}

extension ProductDetailViewController: UICollectionViewDelegate {
    
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionLayouts.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionLayout = SectionLayouts(rawValue: section) else { return 0 }
        
        return sectionLayout.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionLayout = SectionLayouts(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        var cell: UICollectionViewCell
        switch sectionLayout {
            case .image:
                cell = configureProductImageCell(for: indexPath)
            case .summary:
                cell = configureProductSummaryCell(for: indexPath)
            case .description:
                cell = configureProductDescriptionCell(for: indexPath)
        }
        
        return cell
    }
}

extension ProductDetailViewController {
    func configureProductImageCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductImageCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? ProductImageCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.itemView.configure(for: productViewModel)
        return cell
    }
    
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

private extension ProductImageItemView {
    func configure(for viewModel: ProductViewModel) {
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        productImage.kf.setImage(with: viewModel.imageUrl, options: [.processor(processor)])
    }
}

private extension ProductSummaryItemView {
    func configure(for viewModel: ProductViewModel) {
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
