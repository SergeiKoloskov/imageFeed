//
//  Constants.swift
//  imageFeed
//
//  Created by MacBookPro on 18.10.2024.
//

import Foundation

enum Constants {
    static let accessKey = "yaXeW7lJ9X_-vWbG9Fw3yN3pOnMr8PYs6w5aWSYjJ5s"
    static let secretKey = "DhDTj89tUByblo8Y4MLkZ2OyArQEVhOqaosLwn2BlUY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let profileUrl = "https://api.unsplash.com/me"
}
