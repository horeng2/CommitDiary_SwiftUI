//
//  APIProvider.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

import Foundation
import Combine

class GithubNetwork {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func dataRequest(of request: URLRequest) async throws -> Data {
        guard let (data, response) = try? await session.data(for: request)
            else {
            throw NetworkError.invaildData
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let errorCode = String(describing: response)
            throw NetworkError.statusCodeError(code: errorCode)
        }
        
        return data
    }
    
    func getUserInfo(with token: String) async throws -> UserInfo {
        guard let userInfoRequest = UserInfoRequest(token: token).urlRequest else {
            throw NetworkError.urlError
        }
        
        guard let data = try? await dataRequest(of: userInfoRequest) else {
            throw NetworkError.invaildData
        }
        
        guard let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) else {
            throw NetworkError.parsingError(type: "UserInfo")
        }
        
        return userInfo
    }
}
