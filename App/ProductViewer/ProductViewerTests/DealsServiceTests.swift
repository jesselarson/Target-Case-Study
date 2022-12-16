//
//  DealsServiceTests.swift
//  ProductViewerTests
//
//  Created by Jesse Larson on 12/14/22.
//  Copyright © 2022 Target. All rights reserved.
//

import XCTest
@testable import ProductViewer

final class DealsServiceTests: XCTestCase {
    
    private let dealsUrl = "https://api.target.com/mobile_case_study_deals/v1/deals"
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetchDealsReturnsAllDeals() async throws {
        let dealsFilePath = Bundle.main.path(forResource: "ProductList", ofType: "json")
        let dealsJSON = try String(contentsOfFile: dealsFilePath!)
        let mockNetworkingService = MockNetworkingService(data: Data(dealsJSON.utf8))
        
        let dealsService = DealsService(networkingService: mockNetworkingService)
        
        let deals = try await dealsService.fetchDeals()
        XCTAssert(deals.count == 3, "The number of deals in the response should be 3")
    }
    
    func test_fetchProductFound() async throws {
        let productFilePath = Bundle.main.path(forResource: "Product", ofType: "json")
        let productJSON = try String(contentsOfFile: productFilePath!)
        let mockNetworkingService = MockNetworkingService(data: Data(productJSON.utf8))
        
        let dealsService = DealsService(networkingService: mockNetworkingService)
        
        let productId = 1
        let product = try await dealsService.fetchProduct(for: productId)
        XCTAssertTrue(productId == product.id, "The product id of the returned product should match the id used on retrieval")
    }
    
    func test_fetchProductNotFound() async throws {
        let productFilePath = Bundle.main.path(forResource: "Product", ofType: "json")
        let productJSON = try String(contentsOfFile: productFilePath!)
        let mockNetworkingService = MockNetworkingService(data: Data(productJSON.utf8))
        
        let dealsService = DealsService(networkingService: mockNetworkingService)
        
        let productId = 0
        let product = try await dealsService.fetchProduct(for: productId)
        XCTAssertFalse(productId == product.id, "The product id of the returned product should not match the id used on retrieval")
    }
    
    func test_fetchProductNotFoundThrowsItemNotFound() async throws {
        let itemNotFoundFilePath = Bundle.main.path(forResource: "ItemNotFoundResponse", ofType: "json")
        let itemNotFoundJSON = try String(contentsOfFile: itemNotFoundFilePath!)
        
        let productId = 0
        let url = URL(string: dealsUrl + "/\(productId)")!
        let data = Data(itemNotFoundJSON.utf8)
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        let error = NetworkingError.unsuccessfulResponse(response: response!, data: data)
        
        let mockNetworkingService = MockNetworkingService(data: data,  error: error)
        let dealsService = DealsService(networkingService: mockNetworkingService)
        
        // This doesn't work yet. XCTAssertThrowsError isn't available in an async context
        //XCTAssertThrowsError(try await dealsService.fetchProduct(for: productId))
        
        do {
            let _ = try await dealsService.fetchProduct(for: productId)
            XCTFail("fetchProduct was successful for a missing id. Should have thrown DealsServiceError.itemNotFound")
        } catch let error as DealsServiceError {
            XCTAssertEqual(error, DealsServiceError.itemNotFound, "Error should have been DealsServiceError.itemNotFound")
        }
    }
}
