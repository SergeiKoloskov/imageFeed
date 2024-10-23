//
//  URLSession+data.swift
//  imageFeed
//
//  Created by MacBookPro on 21.10.2024.
//

import Foundation
import WebKit

extension URLSession {
//    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
//        
//        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in  // 2
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//        
//        let task = dataTask(with: request, completionHandler: { data, response, error in
//            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                if 200 ..< 300 ~= statusCode {
//                    fulfillCompletionOnTheMainThread(.success(data)) // 3
//                } else {
//                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode))) // 4
//                }
//            } else if let error = error {
//                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error))) // 5
//            } else {
//                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError)) // 6
//            }
//        })
//        
//        return task
//    }
    
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        
        let fulfillCompletionOnTheMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletionOnTheMainThread(.success(result))
                    } catch {
                        fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                    }
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}
