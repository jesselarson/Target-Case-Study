//
//  APIClient.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/9/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct APIClient {
    func retrieveData<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(
                .failure(APIClientError.badUrl)
            )
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(
                    .failure(error)
                )
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(
                    .failure(
                        APIClientError.unsuccessfulResponse(
                            statusCode: response.statusCode
                        )
                    )
                )
            } else {
                guard let data = data else {
                    completion(
                        .failure(APIClientError.unknown)
                    )
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(type, from: data)
                    completion(
                        .success(results)
                    )
                } catch {
                    completion(
                        .failure(
                            APIClientError.parsing(error)
                        )
                    )
                }
            }
        }
        task.resume()
    }
}
