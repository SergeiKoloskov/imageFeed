//
//  ProfileImageService.swift
//  imageFeed
//
//  Created by MacBookPro on 23.10.2024.
//
import UIKit

final class ProfileImageService{
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    private let service = OAuth2Service.shared
    private let storageToke = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private func makeProfileAvatarRequest(_ userName: String) -> URLRequest?{
        guard let url = URL(string: "https://api.unsplash.com/users/\(userName)") else {
            print("URL is not valid")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = storageToke.token
        else { return nil }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String?, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeProfileAvatarRequest(username) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.urlSessionError))
            }
            print("ProfileImageService.fetchProfileImageURL: сессия прервана")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileImageURL):
                    let avatarURL = profileImageURL.profileImage.small
                    self.avatarURL = avatarURL
                    completion(.success(avatarURL))
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL])
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.task = nil
        task.resume()
    }
}
