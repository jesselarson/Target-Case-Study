//
//  Product.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/8/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct Product: Codable {
    var aisle: String
    var availability: String
    var description: String
    var fulfillment: String
    var id: Int
    var imageUrl: String?
    var regularPrice: Price
    var salePrice: Price?
    var title: String
}
