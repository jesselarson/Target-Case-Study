//
//  ErrorView.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation
import UIKit

public enum ErrorType {
    case itemNotFound
    case unknown
    
    var displayMessage: String {
        switch self {
            case .itemNotFound:
                return "This item is no longer available"
            case .unknown:
                return "Unable to load content"
        }
    }
}

final class ErrorView: UIView {
    
    private let warningImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .grayMedium
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Unable to load content"
        return label
    }()
    
    private var errorType: ErrorType = .unknown
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .background
        setError(.unknown)
        
        // Add error message to view
        let stackView = UIStackView(
            arrangedSubviews: [warningImageView, errorMessageLabel]
        )
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        addAndCenterSubview(stackView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("NSCoder not implemented")
    }
}

extension ErrorView {
    public func setError(_ type: ErrorType) {
        errorMessageLabel.text = type.displayMessage
    }
}
