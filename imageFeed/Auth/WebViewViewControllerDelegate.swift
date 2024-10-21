//
//  WebViewViewControllerDelegate.swift
//  imageFeed
//
//  Created by MacBookPro on 22.10.2024.
//

import Foundation

import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
//    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
