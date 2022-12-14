//
//  ProductSummaryItemView.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit

final class ProductSummaryItemView: UIView {
    /// Product image
    ///
    /// Retrieved asynchronously
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    /// Product title
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Product title"
        label.textColor = .black
        label.font = .Details.title
        label.numberOfLines = 0
        return label
    }()
    
    /// Sale price of the product. May equal regular price is no salePrice is on the response
    let salePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$8.99"
        label.textColor = .targetRed
        label.font = .largeBold
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        return label
    }()
    
    /// Non-sale price of the product
    let regularPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "reg $9.99"
        label.textColor = .grayDarkest
        label.font = .small
        label.numberOfLines = 1
        return label
    }()

    /// Item fulfillment (e.g., online, in store, etc)
    let fulfillmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Online"
        label.textColor = .grayMedium
        label.font = .Details.copy2
        label.numberOfLines = 1
        return label
    }()
    
    /// 1pt separator at the bottom of the section
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
        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalTo: widthAnchor, constant: -36),
            productImage.heightAnchor.constraint(equalTo: widthAnchor, constant: -36),
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            
            titleLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 36),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
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
