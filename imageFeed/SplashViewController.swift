//
//  SplashViewController.swift
//  imageFeed
//
//  Created by MacBookPro on 21.10.2024.
//

import UIKit

final class SplashViewController: UIViewController, SplashViewControllerDelegate {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"

    private let authService = OAuth2Service.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    private let service = ProfileService.shared
    private let imageServise = ProfileImageService.shared

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if tokenStorage.token != nil {
            guard let token = tokenStorage.token else { return }
            fetchProfile(token: token)
        } else {
            // Show Auth Screen
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
        
        guard let token = tokenStorage.token else {
            return
        }
        fetchProfile(token: token)
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        service.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.fetchProfileImage(username: user.userName)
            case .failure:
                break
            }
        }
    }
    
    private func fetchProfileImage(username: String) {
        UIBlockingProgressHUD.show()
        imageServise.fetchProfileImageURL(username: username) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                break
            }
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            self?.fetchOAuthToken(code)
            UIBlockingProgressHUD.show()
        }
    }

    private func fetchOAuthToken(_ code: String) {
        authService.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
}
