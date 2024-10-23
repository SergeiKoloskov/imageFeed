//
//  ProfileResult.swift
//  imageFeed
//
//  Created by MacBookPro on 23.10.2024.
//

import UIKit

struct ProfileResult: Codable {
    let userName: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}