//
//  AuthViewControllerDelegate.swift
//  imageFeed
//
//  Created by MacBookPro on 22.10.2024.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
