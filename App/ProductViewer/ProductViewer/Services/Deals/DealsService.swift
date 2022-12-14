//
//  DealsService.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct DealsService: DealsServiceProtocol {
    static var timesExecuted = 0
    private let dealsUrl = "https://api.target.com/mobile_case_study_deals/v1/deals"
    private var networkingService: Networking
    
    init(networkingService: Networking = NetworkingService()) {
        self.networkingService = networkingService
    }
    
    func fetchDeals(successCallback: @escaping ([Product]?) -> (), errorCallback: @escaping (_ error: Error) -> ()) {
        let url = URL(string: dealsUrl)!
        networkingService.retrieveData(url: url) { result in
            switch result {
                case .success((_, let data)):
                    let productList = decodeProductList(from: data)
                    successCallback(productList?.products)
                case .failure(let error):
                    let dealsError = dealsErrorForResponseError(error)
                    errorCallback(dealsError)
            }
        }
    }
    
    func fetchProduct(for id: Int, successCallback: @escaping (Product?) -> (), errorCallback: @escaping (Error) -> ()) {
        let urlString = dealsUrl + "/\(id)"
        let url = URL(string: urlString)!
        
        networkingService.retrieveData(url: url) { result in
            switch result {
                case .success((_, let data)):
                    let product = decodeProductDetail(from: data)
                    successCallback(product)
                case .failure(let error):
                    let dealsError = dealsErrorForResponseError(error)
                    errorCallback(dealsError)
            }
        }
        
        DealsService.timesExecuted += 1
    }
    
    func decodeProductList(from data: Data) -> ProductList? {
        let productList = try? JSONDecoder().decode(ProductList.self, from: data)
        return productList
    }
    
    func decodeProductDetail(from data: Data) -> Product? {
        let product = try? JSONDecoder().decode(Product.self, from: data)
        return product
    }
    
    func dealsErrorForResponseError(_ error: Error) -> DealsServiceError {
        var dealsServiceError = DealsServiceError.unknown
        if let networkingError = error as? NetworkingError {
            switch networkingError {
                case .unsuccessfulResponse(let response, let data):
                    dealsServiceError = isItemNotFoundResponse(response, data: data)
                case .badUrl, .unknown:
                    dealsServiceError = .unknown
            }
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
