//
//  NetworkingService.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/9/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct NetworkingService: Networking {
    
    func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkingError.unknown
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw NetworkingError.unsuccessfulResponse(response: response, data: data)
        }
        
        return data
    }
}
