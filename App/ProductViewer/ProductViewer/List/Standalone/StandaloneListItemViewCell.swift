//
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit

final class StandaloneListItemView: UIView {
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some sort of title that describes the product for this deal"
        label.textColor = .black
        label.font = .medium
        label.numberOfLines = 0
        return label
    }()

    let availabiiltyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "In stock in aisle J12"
        label.textColor = .targetTextGreen
        label.font = .small
        label.numberOfLines = 0
        return label
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
        
        // TODO: Do not use numbers for the constants
        // TODO: Consider a vertical stackview for the right side of the cell
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 172),
            productImage.heightAnchor.constraint(lessThanOrEqualToConstant: 140),
            productImage.widthAnchor.constraint(equalTo: productImage.heightAnchor),
            productImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            salePriceLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 16),
            salePriceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            salePriceLabel.bottomAnchor.constraint(equalTo: fulfillmentLabel.topAnchor, constant: -5),
            
            regularPriceLabel.leadingAnchor.constraint(equalTo: salePriceLabel.trailingAnchor, constant: 5),
            regularPriceLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            regularPriceLabel.bottomAnchor.constraint(equalTo: salePriceLabel.bottomAnchor, constant: -3),
            
            fulfillmentLabel.leadingAnchor.constraint(equalTo: salePriceLabel.leadingAnchor),
            fulfillmentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            fulfillmentLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -15),
            
            titleLabel.leadingAnchor.constraint(equalTo: salePriceLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: availabiiltyLabel.topAnchor, constant: -15),
            
            availabiiltyLabel.leadingAnchor.constraint(equalTo: salePriceLabel.leadingAnchor),
            availabiiltyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            availabiiltyLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StandaloneListItemViewCell: UICollectionViewCell {
    static let reuseIdentifier = "StandaloneListItemViewCell"
    
    lazy var listItemView: StandaloneListItemView = {
        let view = StandaloneListItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addAndPinSubview(contentView)
        
        contentView.addAndPinSubview(listItemView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
