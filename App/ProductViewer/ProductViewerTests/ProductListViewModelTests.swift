//
//  ProductListViewModelTests.swift
//  ProductViewerTests
//
//  Created by Jesse Larson on 12/14/22.
//  Copyright © 2022 Target. All rights reserved.
//

import XCTest
@testable import ProductViewer

final class ProductListViewModelTests: XCTestCase {

    var deals: ProductList!
    var product: Product!
    
    override func setUpWithError() throws {
        deals = Bundle.main.decodeJSONFile(ProductList.self, from: "ProductList.json")
        product = Bundle.main.decodeJSONFile(Product.self, from: "Product.json")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ProductListModelExcecutesSuccessCompletionHandler() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductListViewModel(dealsService: mockDealsService)
        
        var testString = "Before execution"
        let testSuccess: () -> () = {
            testString = "Success"
        }
        
        let testError: (_ error: Error) -> () = { error in
            testString = "Error"
        }
        
        await viewModel.fetchDeals(onSuccess: testSuccess, onError: testError)
        XCTAssertTrue(testString == "Success", "testString should be updated to the value inside the success completion handler")
    }
    
    func test_ProductListModelExcecutesErrorCompletionHandler() async throws {
        let dealsError = DealsServiceError.itemNotFound
        let mockDealsService = MockDealsService(deals: deals, product: product, error: dealsError)
        let viewModel = ProductListViewModel(dealsService: mockDealsService)
        
        var testString = "Before execution"
        let testSuccess: () -> () = {
            testString = "Success"
        }
        
        let testError: (_ error: Error) -> () = { error in
            testString = "Error"
        }
        
        await viewModel.fetchDeals(onSuccess: testSuccess, onError: testError)
        XCTAssertTrue(testString == "Error", "testString should be updated to the value inside the error completion handler")
    }
    
    func test_ProductListViewModelProductAtIndexSuccessful() {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductListViewModel(products: deals.products, dealsService: mockDealsService)
        
        let productIndex = 1
        let productVM = viewModel.productAtIndex(productIndex)
        
        XCTAssertNotNil(productVM, "A valid ProductViewModel should be returned for this index")
    }
    
    func test_ProductListViewModelProductAtIndexFailure() {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductListViewModel(dealsService: mockDealsService)
        
        let productIndex = 5
        let productVM = viewModel.productAtIndex(productIndex)
        
        XCTAssertNil(productVM, "No ProductViewModel should be returned for this index")
    }
}
