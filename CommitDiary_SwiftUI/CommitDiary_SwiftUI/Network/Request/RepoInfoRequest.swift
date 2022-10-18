//
//  RepoInfoRequest.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/16.
//

import Foundation

struct RepoInfoRequest: APIRequest {
    typealias ResponseType = [RepoInfo]
    
    let token: String
    var url: URL? = URL(string: "https://api.github.com/user/repos")
    let httpMethod = "Get"
    var headers: [String: String] {
        ["Accept": "application/vnd.github+json",
         "Authorization": "Bearer \(token)"]
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
