//
//  0Auth2TokenStorage.swift
//  imageFeed
//
//  Created by MacBookPro on 21.10.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let storage: UserDefaults = .standard
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    var token: String? {
        get {
//            storage.string(forKey: "bearerToken")
            KeychainWrapper.standard.string(forKey: "bearerToken")
        }
        set {
//            storage.set(newValue, forKey: "bearerToken")
            guard let token = newValue else { return }
            KeychainWrapper.standard.set(token, forKey: "bearerToken")
        }
    }
}
