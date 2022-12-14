//
//  ProductViewModelTests.swift
//  ProductViewerTests
//
//  Created by Jesse Larson on 12/14/22.
//  Copyright © 2022 Target. All rights reserved.
//

import XCTest

final class ProductViewModelTests: XCTestCase {
    
    var deals: ProductList!
    var product: Product!
    
    override func setUpWithError() throws {
        deals = Bundle.main.decodeJSONFile(ProductList.self, from: "ProductList.json")
        product = Bundle.main.decodeJSONFile(Product.self, from: "Product.json")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_ProductModelId() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        XCTAssertTrue(viewModel.id == 1,
                      "viewModel.id should equal the value used when building the deal service")
    }
    
    func test_ProductModelTitle() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        XCTAssertTrue(viewModel.title == "TCL 32\" Class 3-Series HD Smart Roku TV",
                      "viewModel.title should equal the value used when building the deal service")
    }
    
    func test_ProductModelRegularPriceDisplayString() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        XCTAssertTrue(viewModel.regularPriceDisplayString == "reg. $209.99",
                      "viewModel.regularPriceDisplayString should equal the value used when building the deal service")
    }

    func test_ProductModelSalePriceDisplayString() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        XCTAssertTrue(viewModel.salePriceDisplayString == "$159.99",
                      "viewModel.salePriceDisplayString should equal the value used when building the deal service")
    }
    
    func test_ProductModelFulfillment() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        XCTAssertTrue(viewModel.fulfillment == "Online",
                      "viewModel.fulfillment should equal the value used when building the deal service")
    }

    func test_ProductModelDescription() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        XCTAssertTrue(viewModel.descripition == "The 3-Series TCL Roku TV puts all your entertainment favorites in one place, allowing seamless access to thousands of streaming channels. The simple, personalized home screen allows seamless access to thousands of streaming channels, plus your cable box, Blu-ray player, gaming console, and other devices without flipping through inputs or complicated menus. Easy Voice Control lets you control your entertainment using just your voice. The super-simple remote—with about half the number of buttons on a traditional TV remote—puts you in control of your favorite entertainment. Cord cutters can access free, over-the-air HD content with the Advanced Digital TV Tuner or watch live TV from popular cable-replacement services like YouTube TV, Sling, Hulu and more.",
                      "viewModel.descripition should equal the value used when building the deal service")
    }

    func test_ProductModelAvailabilityDisplayString() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        XCTAssertTrue(viewModel.availabilityDisplayString == "In stock",
                      "viewModel.availabilityDisplayString should equal the value used when building the deal service")
    }
    
    func test_ProductModelAisleDisplayString() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        XCTAssertTrue(viewModel.aisleDisplayString == "in aisle G33",
                      "viewModel.aisleDisplayString should equal the value used when building the deal service")
    }
    
    func test_ProductModelImageUrl() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        let testUrl = URL(string: "https://appstorage.target.com/app-data/native-tha-images/2.jpg")!
        XCTAssertTrue(viewModel.imageUrl == testUrl,
                      "viewModel.imageUrl should equal the value used when building the deal service")
    }

    func test_ProductModelExcecutesSuccessCompletionHandler() async throws {
        let mockDealsService = MockDealsService(deals: deals, product: product)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        var testString = "Before execution"
        let testSuccess: () -> () = {
            testString = "Success"
        }
        
        let testError: (_ error: Error) -> () = { error in
            testString = "Error"
        }
        
        await viewModel.fetchProductDetail(onSuccess: testSuccess, onError: testError)
        
        XCTAssertTrue(testString == "Success", "testString should be updated to the value inside the success completion handler")
    }
    
    func test_ProductModelExcecutesErrorCompletionHandler() async throws {
        let dealsError = DealsServiceError.itemNotFound
        let mockDealsService = MockDealsService(deals: deals, product: product, error: dealsError)
        let viewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        var testString = "Before execution"
        let testSuccess: () -> () = {
            testString = "Success"
        }
        
        let testError: (_ error: Error) -> () = { error in
            testString = "Error"
        }
        
        await viewModel.fetchProductDetail(onSuccess: testSuccess, onError: testError)
        
        XCTAssertTrue(testString == "Error", "testString should be updated to the value inside the error completion handler")
    }
    
    func test_ProductModelUpdatesDescriptionAfterRetrieval() async throws {
        let dealsError = DealsServiceError.itemNotFound
        let mockDealsService = MockDealsService(deals: deals, product: product, error: dealsError)
        let productListViewModel = ProductListViewModel(products: deals.products, dealsService: mockDealsService)
        let productViewModel = ProductViewModel(product: product, dealsService: mockDealsService)
        
        let testSuccess: () -> () = {
        }
        
        let testError: (_ error: Error) -> () = { error in
            
        }
        
        let productIndex = 1
        let preFetchProductViewModel = productListViewModel.productAtIndex(productIndex)
        let descriptionPreFetch = preFetchProductViewModel?.descripition
        
        await productViewModel.fetchProductDetail(onSuccess: testSuccess, onError: testError)
        let descriptionPostFetch = productViewModel.descripition
        
        XCTAssertFalse(descriptionPreFetch == descriptionPostFetch,
                       "testString should be updated to the value inside the error completion handler")
    }
    
    

}
