//
//  NetworkingError.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case badUrl
    case unsuccessfulResponse(statusCode: Int, code: String?, message: String?)
    case parsing(Error)
    case unknown
}
