//
//  Profile.swift
//  imageFeed
//
//  Created by MacBookPro on 23.10.2024.
//
import UIKit

struct Profile{
    let userName: String
    let name: String
    let loginName: String
    let bio: String
    
    init(madeProfile: ProfileResult) {
        self.userName = madeProfile.userName
        self.name = ("\(madeProfile.firstName ?? "") \(madeProfile.lastName ?? "")")
        self.loginName = "@\(madeProfile.userName)"
        self.bio = madeProfile.bio ?? ""
    }
}
