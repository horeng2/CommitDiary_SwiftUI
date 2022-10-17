//
//  CommitInfoRequest.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/16.
//

import Foundation

struct CommitInfoRequest: APIRequest {
    typealias ResponseType = [CommitInfo]
    
    let repo: RepoInfo
    let token: String
    var url: URL? {
        URL(string: "https://api.github.com/repos/\(repo.owner.name)/\(repo.repoName)/commits")
    }
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
