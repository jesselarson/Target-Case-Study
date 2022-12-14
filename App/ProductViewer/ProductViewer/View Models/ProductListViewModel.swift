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
    func fetchDeals(onSuccess: @escaping () -> (), onError: @escaping (_ error: Error) -> ()) {

        dealsService.fetchDeals { [weak self] products in
            guard let self = self else { return }
            
            // Only update the model if products is non-optional An optional result could mean a failure.
            // If we had data before, we don't want to overwrite with bad data. Assumption is that prior
            // data is still valid and we don't want to wipe it. Assumption needs to be revisited
            if let products = products {
                self.products = products
            }
            onSuccess()
        } errorCallback: { error in
            onError(error)
        }
    }
}
