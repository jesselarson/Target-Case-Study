//
//  AddToCartView.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation
import UIKit

final class AddToCartView: UIView {
    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .targetRed
        button.setTitle("Add to cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .largeBold
        button.layer.cornerRadius = 8
        return button
    }()

    public var action: (() -> Void)? = nil
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        // Round the top corners
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Add a drop shadow to the top
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        
        // Add button
        addSubview(addToCartButton)
        NSLayoutConstraint.activate([
            addToCartButton.heightAnchor.constraint(equalToConstant: 44),
            addToCartButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            addToCartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped(_:)), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("NSCoder not implemented")
    }
}

extension AddToCartView {
    @objc func addToCartButtonTapped(_ sender: UIButton) {
        guard let action = action else {
            // TODO: remove this print
            print("Add to cart button tapped, but no action was set")
            return
        }

        action()
    }
}
