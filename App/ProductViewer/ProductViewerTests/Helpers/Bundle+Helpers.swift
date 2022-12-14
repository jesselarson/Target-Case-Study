//
//  Bundle+Helpers.swift
//  ProductViewerTests
//
//  Created by Jesse Larson on 12/14/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

extension Bundle {
    func decodeJSONFile<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Decoding failed with error: \(error.localizedDescription)")
        }
    }
}
