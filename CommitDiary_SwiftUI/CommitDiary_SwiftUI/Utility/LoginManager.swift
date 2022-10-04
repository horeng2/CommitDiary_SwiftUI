//
//  LoginManager.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

import Foundation
import UIKit

struct LoginManager {
    static let shared = LoginManager()
    static let isLoginKey = "isLogin"
    
    private let clientId = "d7dbc87ea8c0b68452f7"
    private let clientSecret = "9fa2a43c208619ab8f7fb0201b1e3445d565a6cc"
    private let scope = "repo,user"
    
    func requestCode() -> URL {
        let urlString = "https://github.com/login/oauth/authorize"
        var components = URLComponents(string: urlString)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "scope", value: self.scope),
        ]
        
        return components.url!
    }
    
    func requestAccessToken(with code: String) {
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
                print(token)
            }
        }
        .resume()
    }
}
