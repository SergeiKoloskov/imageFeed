//
//  0Auth2TokenStorage.swift
//  imageFeed
//
//  Created by MacBookPro on 21.10.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private let storage: UserDefaults = .standard
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    var token: String? {
        get {
            return storage.string(forKey: "bearerToken")
        }
        set {
            storage.set(newValue, forKey: "bearerToken")
        }
    }
}
