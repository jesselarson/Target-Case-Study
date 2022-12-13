//
//  ProductImageCollectionViewCell.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/12/22.
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit
import Kingfisher

final class ProductImageItemView: UIView {
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .white
        
        addSubview(productImage)
        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalTo: widthAnchor),
            productImage.heightAnchor.constraint(equalTo: widthAnchor),
            productImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            productImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProductImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductImageCollectionViewCell"
    
    lazy var itemView: ProductImageItemView = {
        let view = ProductImageItemView()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        itemView.productImage.kf.cancelDownloadTask()
    }
}
