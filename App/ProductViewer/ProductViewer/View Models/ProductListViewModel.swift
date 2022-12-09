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
}
