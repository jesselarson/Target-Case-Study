//
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit
import Kingfisher

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
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        return label
    }()
    
    let regularPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "reg $9.99"
        label.textColor = .grayDarkest
        label.font = .small
        label.numberOfLines = 1
        return label
    }()

    let fulfillmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Online"
        label.textColor = .grayMedium
        label.font = .small
        label.numberOfLines = 1
        return label
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
    
    let aisleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "in aisle J12"
        label.textColor = .grayMedium
        label.font = .small
        label.numberOfLines = 1
        return label
    }()
    
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
            heightAnchor.constraint(greaterThanOrEqualToConstant: 172),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: productImage.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.topAnchor.constraint(equalTo: topAnchor),
            
            productImage.heightAnchor.constraint(lessThanOrEqualToConstant: 140),
            productImage.widthAnchor.constraint(equalTo: productImage.heightAnchor),
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        listItemView.separator.isHidden = false
        listItemView.productImage.kf.cancelDownloadTask()
    }
}
