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
    
    func test_NumberOfItemsInSection() {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductListViewModel(products: deals.products, dealsService: mockDealsService)
        
        XCTAssertEqual(viewModel.numberOfItemsInSection(0), 3)
    }

    func test_ProductListModelFetchDealsSuccessful() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductListViewModel(dealsService: mockDealsService)
        
        do {
            try await viewModel.fetchDeals()
            XCTAssertGreaterThan(viewModel.numberOfItemsInSection(0), 0)
        } catch {
            XCTFail("An error was thrown from fetchDeals. Error: \(error))")
        }
    }
    
    func test_ProductListModelThrowsOnError() async throws {
        let dealsError = DealsServiceError.unknown
        let mockDealsService = MockDealsService(deals: deals, product: product, error: dealsError)
        let viewModel = ProductListViewModel(dealsService: mockDealsService)
        
        do {
            try await viewModel.fetchDeals()
            XCTFail("fetchDeals should have thrown a DealsServiceError.unknown")
        } catch let error as DealsServiceError {
            XCTAssertEqual(error, dealsError, "Error should be DealsServiceError.unknown. Actual error: \(error.localizedDescription)")
        }
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
