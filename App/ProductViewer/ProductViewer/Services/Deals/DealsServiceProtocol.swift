//
//  DealsServiceProtocol.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/14/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

protocol DealsServiceProtocol {
    func fetchDeals() async throws -> [Product]
    func fetchProduct(for id: Int) async throws -> Product
}
