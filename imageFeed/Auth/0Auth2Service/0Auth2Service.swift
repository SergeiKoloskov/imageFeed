//
//  0Auth2Service.swift
//  imageFeed
//
//  Created by MacBookPro on 21.10.2024.
//

import Foundation
import WebKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    private let tokenStorage = OAuth2TokenStorage()
    
    
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
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Fatal Error. Fetch authorization requset can not be created")
            fatalError("Fatal Error. Fetch authorization requset can not be created")
        }
        
        URLSession.shared.data(for: request) {[weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    
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
        }.resume()
    }
}
