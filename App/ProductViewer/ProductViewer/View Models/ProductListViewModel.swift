//
//  ProductListViewModel.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/9/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation
import UIKit

class ProductListViewModel {
    private var products: [Product]
    private let dealsUrl = "https://api.target.com/mobile_case_study_deals/v1/deals"
    
    init() {
        products = [Product]()
    }
    
    convenience init(products: [Product]) {
        self.init()
        self.products = products
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
        let url = URL(string: dealsUrl)!
        APIClient().retrieveData(ProductList.self, url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let deals):
                    self.products = deals.products
                    onSuccess()
                case .failure(let error):
                    onError(error)
            }
        }
    }
}
