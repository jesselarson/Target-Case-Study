//
//  NetworkingService.swift
//  ProductViewer
//
//  Created by Jesse Larson on 12/9/22.
//  Copyright © 2022 Target. All rights reserved.
//

import Foundation

struct NetworkingService: Networking {
    
    typealias DataTaskResult = Result<(HTTPURLResponse, Data), Error>

    ///
    func retrieveData(url: URL?, completion: @escaping (DataTaskResult) -> Void) {
        
        // Validate we have a valid URL before proceeding
        guard let url = url else {
            completion(
                .failure(NetworkingError.badUrl)
            )
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Some sort of transient network error occurred before the request could complete
            if let error = error {
                completion(.failure(error))
                
            // Verify the response is an HTTPURLResponse. If so, test the status code for a successful response
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                // Non-successful HTTP response code. Send response and data back on the error
                completion(
                    .failure(NetworkingError.unsuccessfulResponse(response: response, data: data))
                )
            } else {
                // We have a successful response. Unwrap the response and data
                guard let response = response as? HTTPURLResponse, let data = data else {
                    completion(.failure(NetworkingError.unknown))
                    return
                }
                
                // success!
                completion(.success((response, data)))
            }
        }
        task.resume()
    }
    
    ///
//    func retrieveData<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = url else {
//            completion(
//                .failure(NetworkingError.badUrl)
//            )
//            return
//        }
//        
//        let request = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            // Some sort of transient network error occurred before the request could complete
//            if let error = error {
//                completion(
//                    .failure(error)
//                )
//                
//            // If a 404, look for an ItemNotFoundResponse object in the body
//            } else if let response = response as? HTTPURLResponse, response.statusCode == 404, let data = data {
//                do {
//                    let errorResponse = try JSONDecoder().decode(ItemNotFoundResponse.self, from: data)
//                    
//                    // Pass back an error specific to the item not being found
//                    completion(
//                        .failure(
//                            NetworkingError.unsuccessfulResponse(
//                                statusCode: response.statusCode,
//                                code: errorResponse.code,
//                                message: errorResponse.message
//                            )
//                        )
//                    )
//                } catch {
//                    // Could not parse ItemNotFoundResponse. Send the 404 back as an unsuccsesful response
//                    completion(
//                        .failure(
//                            NetworkingError.unsuccessfulResponse(
//                                statusCode: response.statusCode,
//                                code: nil,
//                                message: nil
//                            )
//                        )
//                    )
//                }
//                
//            // If an unsuccessful HTTP response code other than 404, send back an unsuccessful response
//            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
//                // Non-successful HTTP response code
//                completion(
//                    .failure(
//                        NetworkingError.unsuccessfulResponse(
//                            statusCode: response.statusCode,
//                            code: nil,
//                            message: nil
//                        )
//                    )
//                )
//                
//            // We have a successful response. Attempt to parse the data using the type sent by the caller
//            } else {
//                
//                // verify we have a valid response body
//                guard let data = data else {
//                    completion(
//                        .failure(NetworkingError.unknown)
//                    )
//                    return
//                }
//                
//                // We should have a successful request with valid data at this point
//                // Attempt to parse the response data using the Type sent from the caller
//                do {
//                    let results = try JSONDecoder().decode(type, from: data)
//                    completion(
//                        .success(results)
//                    )
//                } catch {
//                    completion(
//                        .failure(
//                            NetworkingError.parsing(error)
//                        )
//                    )
//                }
//            }
//        }
//        task.resume()
//    }
}
