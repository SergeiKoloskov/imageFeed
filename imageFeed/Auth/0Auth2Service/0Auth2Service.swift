//
//  0Auth2Service.swift
//  imageFeed
//
//  Created by MacBookPro on 21.10.2024.
//

import Foundation
import WebKit

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    private let tokenStorage = OAuth2TokenStorage.shared
    private let decoder = JSONDecoder()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let baseURL = URL(string: "https://unsplash.com")
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"         // Используем знак ?, чтобы начать перечисление параметров запроса
            + "&&client_secret=\(Constants.secretKey)"    // Используем &&, чтобы добавить дополнительные параметры
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL                           // Опираемся на основной или базовый URL, которые содержат схему и имя хоста
        ) else {
            fatalError("Fatal Error. Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if task != nil {
            guard lastCode != code else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
            task?.cancel()
        }
        
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Fatal Error. Fetch authorization requset can not be created")
            fatalError("Fatal Error. Fetch authorization requset can not be created")
        }
        
        let task = URLSession.shared.data(for: request) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        //                    let decoder = JSONDecoder()
                        guard let response = try self?.decoder.decode(OAuthTokenResponseBody.self, from: data)
                        else { return }
                        
                        guard let self else { return }
                        self.tokenStorage.token = response.accessToken
                        
                        completion(.success(response.accessToken))
                    } catch {
                        print("Error occured while decoding the OAuth token response: \(error)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Error occured while fetching OAuth token: \(error)")
                    completion(.failure(error))
                }
                
                self?.task = nil
                self?.lastCode = nil
                
            }
        }
        
        self.task = task
        task.resume()
    }
}
