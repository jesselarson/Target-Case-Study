//
//  DealsServiceProtocol.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/14/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

protocol DealsServiceProtocol {
    func fetchDeals(successCallback: @escaping ([Product]?) -> (), errorCallback: @escaping (_ error: Error) -> ())
    func fetchProduct(for id: Int, successCallback: @escaping (Product?) -> (), errorCallback: @escaping (_ error: Error) -> ())
}
