//
//  ProductViewModel.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/9/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

class ProductViewModel {
    private var product: Product
    private var dealsService: DealsServiceProtocol
    
    init(product: Product, dealsService: DealsServiceProtocol = DealsService()) {
        self.product = product
        self.dealsService = dealsService
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
    func fetchProductDetail() async throws {
        do {
            let product = try await dealsService.fetchProduct(for: id)
            self.product = product
        } catch {
            throw error
        }
    }
}
