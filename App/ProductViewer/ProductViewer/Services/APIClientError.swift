//
//  APIClientError.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

enum APIClientError: Error {
    case badUrl
    case unsuccessfulResponse(statusCode: Int)
    case parsing(Error)
    case unknown
}
