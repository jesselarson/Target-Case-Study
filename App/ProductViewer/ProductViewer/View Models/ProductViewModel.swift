//
//  ProductViewModel.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/9/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation
import UIKit

struct ProductViewModel {
    private let product: Product
    
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
        return product.regularPrice.displayString
    }
    
    var salePriceDisplayString: String? {
        return product.salePrice?.displayString
    }
    
    var fulfillment: String {
        return product.fulfillment
    }
    
    var descripition: String {
        return product.description
    }
    
    var availabilityDisplayString: String {
        return "\(product.availability) in aisle \(product.aisle)"
    }
    
//    var image: UIImage? {
//        
//    }
    
}
