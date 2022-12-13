//
//  ProductSummaryCollectionViewCell.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/12/22.
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit

final class ProductSummaryItemView: UIView {
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Product title"
        label.textColor = .black
        label.font = .medium
        label.numberOfLines = 0
        return label
    }()
    
    let salePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$8.99"
        label.textColor = .targetRed
        label.font = .largeBold
        label.numberOfLines = 0
        return label
    }()
    
    let regularPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "reg $9.99"
        label.textColor = .grayDarkest
        label.font = .small
        label.numberOfLines = 0
        return label
    }()

    let fulfillmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Online"
        label.textColor = .grayMedium
        label.font = .small
        label.numberOfLines = 0
        return label
    }()
    
    private let bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.thinBorderGray
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .white
        
        addSubview(productImage)
        addSubview(titleLabel)
        addSubview(salePriceLabel)
        addSubview(regularPriceLabel)
        addSubview(fulfillmentLabel)
        addSubview(bottomLine)
        
        // TODO: Do not use numbers for the constants
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalTo: widthAnchor),
            productImage.heightAnchor.constraint(equalTo: widthAnchor),
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImage.topAnchor.constraint(equalTo: topAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: salePriceLabel.topAnchor, constant: -15),
            
            salePriceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            salePriceLabel.bottomAnchor.constraint(equalTo: fulfillmentLabel.topAnchor, constant: -5),
            
            regularPriceLabel.leadingAnchor.constraint(equalTo: salePriceLabel.trailingAnchor, constant: 6),
            regularPriceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            regularPriceLabel.bottomAnchor.constraint(equalTo: salePriceLabel.bottomAnchor, constant: -2),
            
            fulfillmentLabel.leadingAnchor.constraint(equalTo: salePriceLabel.leadingAnchor),
            fulfillmentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            fulfillmentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLine.topAnchor.constraint(equalTo: bottomAnchor)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProductSummaryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductSummaryCollectionViewCell"
    
    lazy var itemView: ProductSummaryItemView = {
        let view = ProductSummaryItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addAndPinSubview(contentView)
        
        contentView.addAndPinSubview(itemView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
