//
//  ItemNotFoundResponse.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/13/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct ItemNotFoundResponse: Codable {
    var message: String
    var code: String
}
