//
//  MockDealsService.swift
//  ProductViewerTests
//
//  Created by Jesse Larson on 12/14/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct MockDealsService: DealsServiceProtocol {
    var deals: ProductList
    var error: Error?

    init(deals: ProductList, error: Error? = nil) {
        self.deals = deals
        self.error = error
    }
    
    func fetchDeals() async throws -> [Product] {
        if let error = error {
            throw error
        }
        
        return deals.products
    }
    
    func fetchProduct(for id: Int) async throws -> Product {
        if let error = error {
            throw error
        }
        
        guard let product = deals.products.first else {
            throw DealsServiceError.unknown
        }
        
        return product
    }
    
    
}
