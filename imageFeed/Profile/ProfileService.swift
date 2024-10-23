//
//  ProfileService.swift
//  imageFeed
//
//  Created by MacBookPro on 23.10.2024.
//

import UIKit


final class ProfileService {
    private var lastCode: String?
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    static let shared = ProfileService()
    private init() {}
    
    private func createRequest(token: String) -> URLRequest? {
        
        guard let url = URL(string: Constants.profileUrl)
        else {
            print("Given url is invalid")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == token {return}
        task?.cancel()
        lastCode = token
        
        guard let request = createRequest(token: token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
            
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>)  in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let madeProfile):
                    let user = Profile(madeProfile: madeProfile)
                    completion(.success(user))
                    self.profile = user
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
}
