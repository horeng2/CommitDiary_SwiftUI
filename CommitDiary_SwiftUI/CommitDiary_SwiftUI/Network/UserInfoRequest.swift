//
//  UserInfoRequest.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

import Foundation

struct UserInfoRequest {
    let token: String
    var url: URL? = URL(string: "https://api.github.com/user")
    let httpMethod = "Get"
    var headers: [String: String] {
        ["Authorization": "token \(token)",
         "Accept": "application/vnd.github.v3+json"]
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        self.headers.forEach{ key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
