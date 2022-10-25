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
    
    func login(with temporaryCode: URL) async {
        let code = temporaryCode.absoluteString.components(separatedBy: "code=").last ?? ""
        guard let token = try? await requestAccessToken(with: code) else {
            return
        }
        Keychain.create(key: LoginManager.tokenKey, token: token)
        isLogin = true
    }
    
    func logout() {
        Keychain.delete(key: LoginManager.tokenKey)
        UserDefaults.standard.removeObject(forKey: "userId")
        isLogin = false
    }
    
    private func requestAccessToken(with code: String) async throws -> String {
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

        guard let (data, response) = try? await URLSession.shared.data(for: request)
            else {
            throw NetworkError.invaildData
        }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let errorCode = String(describing: response)
            print(errorCode)
            throw NetworkError.statusCodeError(code: errorCode)
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let parsedData = json as? [String: Any],
              let token = parsedData["access_token"] as? String else {
            throw NetworkError.parsingError(type: "JSON")
        }
            
        return token
    }
}
