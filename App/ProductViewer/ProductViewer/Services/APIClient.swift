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
    func retrieveData<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(NetworkingError.badDataError)) // TODO: make this a url error
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(.failure(NetworkingError.unsuccessfulRequestError)) // TODO: make this a bad response error and pass statuscode
            } else {
                guard let data = data else {
                    completion(.failure(NetworkingError.badDataError))
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(type, from: data)
                } catch {
                    completion(.failure(NetworkingError.decodingError)) // TODO: pass decoding error back
                }
            }
        }
        task.resume()
    }
}
