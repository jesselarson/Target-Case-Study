//
//  ProductViewModel.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/9/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation
import UIKit

class ProductViewModel {
    private var product: Product
    private let dealsUrl = "https://api.target.com/mobile_case_study_deals/v1/deals"
    
    init(product: Product) {
        self.product = product
    }
    
    var id: Int {
        return product.id
    }
    
    var title: String {
        return product.title
    }
    
    var regularPriceDisplayString: String {
        return "reg. \(product.regularPrice.displayString)"
    }
    
    var salePriceDisplayString: String? {
        // When there is no salePrice, use the regular price
        // Not much of a deal, but this matches the mocks
        if let salePrice = product.salePrice {
            return salePrice.displayString
        } else {
            return product.regularPrice.displayString
        }
    }
    
    var fulfillment: String {
        return product.fulfillment
    }
    
    var descripition: String {
        return product.description
    }
    
    var availabilityDisplayString: String {
        return product.availability
    }
    
    var aisleDisplayString: String {
        return "in aisle \(product.aisle.capitalized)"
    }
    
    var imageUrl: URL? {
        return URL(string: product.imageUrl ?? "")
    }
    
}

extension ProductViewModel {
    func fetchProductDetail(onSuccess: @escaping () -> (), onError: @escaping (_ error: Error) -> ()) {
        let urlString = dealsUrl + "/\(id)"
        let url = URL(string: urlString)!
        APIClient().retrieveData(Product.self, url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let product):
                    print(product)
                    self.product = product
                    DispatchQueue.main.async {
                        onSuccess()
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        onError(error)
                    }
            }
        }
    }
}
