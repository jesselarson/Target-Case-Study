//
//  Networking.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

typealias DataTaskResult = Result<(HTTPURLResponse, Data), Error>

protocol Networking {
    func retrieveData(url: URL?, completion: @escaping (DataTaskResult) -> Void)
}
