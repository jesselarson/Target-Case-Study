//
//  MockNetworkingService.swift
//  ProductViewerTests
//
//  Created by Jesse Larson on 12/14/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct MockNetworkingService: Networking {
    var data: Data
    var error: Error?
    
    init(data: Data, error: Error? = nil) {
        self.data = data
        self.error = error
    }
    
    func fetchData(from url: URL) async throws -> Data {
        if let error = error {
            throw error
        }
        
        return data
    }
}
