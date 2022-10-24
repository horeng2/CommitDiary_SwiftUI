//
//  LoginManager.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

import Foundation
import SwiftUI

struct LoginManager {
    @AppStorage(LoginManager.isLoginKey) var isLogin = false
    static var shared = LoginManager()
    static let isLoginKey = "isLogin"
    static let tokenKey = "token"
    
    private let clientId = Bundle.main.client_id
    private let clientSecret = Bundle.main.client_secret
    private let scope = "repo,user"

    lazy var loginUrl: URL = {
        let urlString = "https://github.com/login/oauth/authorize"
        var components = URLComponents(string: urlString)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "scope", value: self.scope),
        ]
        
        return components.url!
    }()
    
    private init() { }
    
    func login(with temporaryCode: URL) {
        let code = temporaryCode.absoluteString.components(separatedBy: "code=").last ?? ""
        requestAccessToken(with: code) { token in
            Keychain.create(key: LoginManager.tokenKey, token: token)
        }
        isLogin = true
    }
    
    func logout() {
        Keychain.delete(key: LoginManager.tokenKey)
        UserDefaults.standard.removeObject(forKey: "userId")
        isLogin = false
    }
    
    
    private func requestAccessToken(with code: String, completion: @escaping (String) -> Void)  {
        let urlString = "https://github.com/login/oauth/access_token"
        var components = URLComponents(string: urlString)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "client_secret", value: self.clientSecret),
            URLQueryItem(name: "code", value: code)
        ]
        
        var request = URLRequest(url: components.url!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(NetworkError.invaildData)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print(NetworkError.parsingError(type: "JSON"))
                return
            }
            if let parsedData = json as? [String: Any] {
                let token = parsedData["access_token"] as! String
                completion(token)
            }
        }
        .resume()
    }
}
