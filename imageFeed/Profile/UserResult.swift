//
//  ProfileImageResult.swift
//  imageFeed
//
//  Created by MacBookPro on 23.10.2024.
//
import UIKit

struct UserResult: Codable {
    let profileImage: ImageSize
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageSize: Codable {
    let small: String
    let medium: String
    let large: String
}

