//
//  Networking.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

protocol Networking {
    func retrieveData<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping (Result<T, Error>) -> Void)
}
