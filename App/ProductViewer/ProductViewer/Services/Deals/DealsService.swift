//
//  DealsService.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct DealsService: DealsServiceProtocol {
    private let dealsUrl = "https://api.target.com/mobile_case_study_deals/v1/deals"
    private var networkingService: Networking
    
    init(networkingService: Networking = NetworkingService()) {
        self.networkingService = networkingService
    }
    
    func fetchDeals() async throws -> [Product] {
        do {
            let data = try await networkingService.fetchData(from: URL(string: dealsUrl)!)
            let productList = try JSONDecoder().decode(ProductList.self, from: data)
            return productList.products
        } catch {
            let dealsError = dealsErrorForResponseError(error)
            throw dealsError
        }
    }
    
    func fetchProduct(for id: Int) async throws -> Product {
        do {
            let url = URL(string: dealsUrl + "/\(id)")!
            let data = try await networkingService.fetchData(from: url)
            let product = try JSONDecoder().decode(Product.self, from: data)
            return product
        } catch {
            let dealsError = dealsErrorForResponseError(error)
            throw dealsError
        }
    }
    
    func dealsErrorForResponseError(_ error: Error) -> DealsServiceError {
        var dealsServiceError = DealsServiceError.unknown
        if let networkingError = error as? NetworkingError {
            switch networkingError {
                case .unsuccessfulResponse(let response, let data):
                    dealsServiceError = isItemNotFoundResponse(response, data: data)
                case .unknown:
                    dealsServiceError = .unknown
            }
        } else if let _ = error as? DecodingError {
            dealsServiceError = .parsing
        }
        
        return dealsServiceError
    }
    
    /// Parses the data on an `NetworkingError.unsuccessfulResponse`to determine if it's a 404 with an ItemNotFoundResponse object in the body.
    /// Returns a `DealsServiceError.itemNotFound` error if found, otherwise returns `DealsServiceError.unknown`
    /// - parameter response: `HTTPURLResponse` object from the unsuccessful networking request
    /// - parameter data: Optional `Data` object from the unsuccessful networking request
    func isItemNotFoundResponse(_ response: HTTPURLResponse, data: Data?) -> DealsServiceError {
        var error = DealsServiceError.unknown
        if let data = data, response.statusCode == 404 {
            if let errorResponse = try? JSONDecoder().decode(ItemNotFoundResponse.self, from: data),
               errorResponse.code == "ITEM_NOT_FOUND" {
                error = .itemNotFound
            }
        }
        
        return error
    }
}
