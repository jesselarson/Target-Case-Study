//
//  ProductListViewModel.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/9/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct ProductListViewModel {
    private let products: [Product]
    
    init(products: [Product]) {
        self.products = products
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return products.count
    }
    
    func productAtIndex(_ indexPath: IndexPath) -> ProductViewModel? {
        if products.indices.contains(indexPath.row) {
            return ProductViewModel(product: products[indexPath.row])
        } else {
            return nil
        }
    }
}
