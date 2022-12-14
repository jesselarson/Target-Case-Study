//
//  ProductListViewModel.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/9/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

protocol ProductListViewModelProtocol {
    func fetchDeals(onSuccess: @escaping () -> (), onError: @escaping (_ error: Error) -> ())
}

class ProductListViewModel {
    private var products: [Product]
    private var dealsService: DealsServiceProtocol
    
    init(dealsService: DealsServiceProtocol = DealsService()) {
        products = [Product]()
        self.dealsService = dealsService
    }
    
    convenience init(products: [Product], dealsService: DealsServiceProtocol = DealsService()) {
        self.init()
        self.products = products
        self.dealsService = dealsService
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return products.count
    }
    
    func productAtIndex(_ indexPath: IndexPath) -> ProductViewModel? {
        if products.indices.contains(indexPath.row) {
            return ProductViewModel(product: products[indexPath.row])
        } else {
            return nil
        }
    }
}

extension ProductListViewModel {
    func fetchDeals(onSuccess: @escaping () -> (), onError: @escaping (_ error: Error) -> ()) async {
        do {
            let products = try await dealsService.fetchDeals()
            self.products = products
            onSuccess()
        } catch {
            onError(error)
        }
    }
}
