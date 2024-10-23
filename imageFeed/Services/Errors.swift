//
//  Errors.swift
//  imageFeed
//
//  Created by MacBookPro on 23.10.2024.
//

import UIKit

enum NetworkError: Error {  // 1
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

enum AuthServiceError: Error {
    case invalidRequest
}

enum ProfileServiceError: Error {
    case invalidRequest
}
