//
//  ContributionsRequest.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/05.
//

import Foundation

struct ContributionsRequest {
    let userId: String
    private let scheme = "https"
    private let host = "github.com"
    private let path = "/users"
    
    var component: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + "/\(userId)" + "/contributions"
        
        return components
    }
    
    var urlReauest: URLRequest? {
        guard let url = component.url else {
            return nil
        }
        return URLRequest(url: url)
    }
}
