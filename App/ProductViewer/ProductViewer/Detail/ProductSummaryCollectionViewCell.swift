//
//  ProductSummaryCollectionViewCell.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/12/22.
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit

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
