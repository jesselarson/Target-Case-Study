//
//  APIClient.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/9/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case unsuccessfulRequestError
    case badDataError
    case decodingError
}

struct APIClient {
    func retrieveDeals(completion: @escaping (Result<[Product], Error>) -> Void) {
        // TODO: Make this a configuration item. Create a new URLRequest and send to method
        let url = URL(string: "https://api.target.com/mobile_case_study_deals/v1/deals")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(.failure(NetworkingError.unsuccessfulRequestError))
            } else {
                guard let data = data else {
                    completion(.failure(NetworkingError.badDataError))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let productList = try decoder.decode(ProductList.self, from: data)
                    completion(.success(productList.products))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
