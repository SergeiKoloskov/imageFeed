//
//  SplashViewControllerDelegate.swift
//  imageFeed
//
//  Created by MacBookPro on 22.10.2024.
//

import Foundation

protocol SplashViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
