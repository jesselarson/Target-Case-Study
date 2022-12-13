//
//  ProductDetailViewController.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/12/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation
import UIKit

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
    
    var height: CGFloat {
        switch self {
            case .image:
                return 400.0
            case .summary:
                return 100.0
            case .description:
                return 200.0
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
            case .image:
                return .blue
            case .summary:
                return .yellow
            case .description:
                return .red
        }
    }
}

final class ProductDetailViewController: UIViewController {
    private let productViewModel: ProductViewModel
    
    private let addToCartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
//        // Add button
//        let button = UIButton()
//        button.titleLabel?.text = "Add to cart"
//        button.backgroundColor = .targetRed
//        button.
//        view.addSubview(button)
        
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
        view.addAndPinSubview(addToCartView, edges: [.left, .right, .bottom])
        let heightConstraint = addToCartView.heightAnchor.constraint(equalToConstant: 140)
        view.addConstraints([heightConstraint])

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
            
            let esimatedHeight = sectionLayout.height
            
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
        
        // TODO: do all configuration in the methods above
        cell.backgroundColor = sectionLayout.backgroundColor
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
        
        //configure
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
