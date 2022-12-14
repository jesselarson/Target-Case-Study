//
//  DealsServiceError.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/14/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

enum DealsServiceError: Error {
    case itemNotFound
    case parsing(Error)
    case unknown
}
