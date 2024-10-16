//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by MacBookPro on 16.10.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBAction private func didTapLogoutButton() {
    }
    
    @IBOutlet private var logoutButton: UIButton!
}
