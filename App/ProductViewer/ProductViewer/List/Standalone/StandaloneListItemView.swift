//
//  StandaloneListItemView.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit

final class StandaloneListItemView: UIView {
    /// Thumbnail image of the product.
    ///
    /// This image will be lazy loaded once the list of deals has been retrieved
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    /// Sale price of the deal. Note that this value may equal the regular price
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
    
    /// Regular price of the product
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
        label.font = .small
        label.numberOfLines = 1
        return label
    }()

    /// Product title for the deal
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Product title"
        label.textColor = .black
        label.font = .medium
        label.numberOfLines = 0
        return label
    }()

    /// Availability of the product for this deal (e.g., In stock)
    let availabiiltyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "In stock"
        label.textColor = .targetTextGreen
        label.font = .small
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        return label
    }()
    
    /// Aisle location for the product in the store
    let aisleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "in aisle J12"
        label.textColor = .grayMedium
        label.font = .small
        label.numberOfLines = 1
        return label
    }()
    
    /// 1-pt separator between views to give a table view list appearance.
    ///
    /// This separator will appear at the top of the cell to make it convenient for a caller
    /// to hide the separator for the first cell in the list
    /// NOTE: A switch to collection view list configurations will eliminate this need
    let separator: UIView = {
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
        addSubview(salePriceLabel)
        addSubview(regularPriceLabel)
        addSubview(fulfillmentLabel)
        addSubview(titleLabel)
        addSubview(availabiiltyLabel)
        addSubview(aisleLabel)
        addSubview(separator)
        
        // TODO: Do not use numbers for the constants
        NSLayoutConstraint.activate([
            // Force a constant cell height
            heightAnchor.constraint(greaterThanOrEqualToConstant: 172),
            
            // Configure a 1-pt separator at the top
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: productImage.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.topAnchor.constraint(equalTo: topAnchor),
            
            productImage.widthAnchor.constraint(lessThanOrEqualToConstant: productImageWidth()),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor),
            productImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            salePriceLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 16),
            salePriceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            salePriceLabel.bottomAnchor.constraint(equalTo: fulfillmentLabel.topAnchor, constant: -5),
            
            regularPriceLabel.leadingAnchor.constraint(equalTo: salePriceLabel.trailingAnchor, constant: 6),
            regularPriceLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            regularPriceLabel.bottomAnchor.constraint(equalTo: salePriceLabel.bottomAnchor, constant: -2),
            
            fulfillmentLabel.leadingAnchor.constraint(equalTo: salePriceLabel.leadingAnchor),
            fulfillmentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            fulfillmentLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -15),
            
            titleLabel.leadingAnchor.constraint(equalTo: salePriceLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: availabiiltyLabel.topAnchor, constant: -15),
            
            availabiiltyLabel.leadingAnchor.constraint(equalTo: salePriceLabel.leadingAnchor),
            availabiiltyLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16),
            
            aisleLabel.leadingAnchor.constraint(equalTo: availabiiltyLabel.trailingAnchor, constant: 4),
            aisleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            aisleLabel.bottomAnchor.constraint(equalTo: availabiiltyLabel.bottomAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Returns a `CGFloat` that can be used for the image width (and height) to ensure the image does not
    /// use too much of the cell width on smaller devices.
    func productImageWidth() -> CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return screenWidth >= 375.0 ? 140.0 : 80.0
    }
}
