//
//  APIProvider.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

import Foundation

class APICaller {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request(_ request: UserInfoRequest, completionHandler: @escaping (Result<UserInfo, NetworkError>) -> Void) {
        guard let urlRequest = request.urlRequest else {
            return
        }
        session.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      let errorCode = String(describing: response)
                      return completionHandler(.failure(.statusCodeError(code: errorCode)))
                  }
            guard let data = data else {
                return completionHandler(.failure(.invaildData))
            }
            
            guard let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) else {
                return
            }
            print(userInfo)
            completionHandler(.success(userInfo))
        }
        .resume()
    }
}
