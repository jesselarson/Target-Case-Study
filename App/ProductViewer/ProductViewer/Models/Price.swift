//
//  Price.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/8/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct Price: Codable {
    var amountInCents: Int
    var currencySymbol: String
    var displayString: String
    
    enum CodingKeys: String, CodingKey {
        case amountInCents = "amount_in_cents"
        case currencySymbol = "currency_symbol"
        case displayString = "display_string"
    }
}
