//
//  GithubNetwork.swift
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
    
    func dataRequest<T: APIRequest>(of requestType: T) async throws -> T.ResponseType {
        guard let request = requestType.urlRequest else {
            throw NetworkError.urlError
        }
        guard let (data, response) = try? await session.data(for: request)
            else {
            throw NetworkError.invaildData
        }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let errorCode = String(describing: response)
            print(errorCode)
            throw NetworkError.statusCodeError(code: errorCode)
        }
        
        guard let decodedData = try? JSONDecoder().decode(T.ResponseType.self, from: data) else {
            throw NetworkError.parsingError(type: "\(T.ResponseType.self)")
        }
        return decodedData
    }

    
    func getContributions(with userId: String) async throws -> [Contribution] {
        guard let contributionRequest = ContributionsRequest(userId: userId).urlReauest else {
            throw NetworkError.urlError
        }
        guard let (data, response) = try? await session.data(for: contributionRequest)
            else {
            throw NetworkError.invaildData
        }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let errorCode = String(describing: response)
            throw NetworkError.statusCodeError(code: errorCode)
        }
  
        guard let html = String(data: data, encoding: .utf8) else {
            throw HTMLError.encodingError
        }
        let classBlock = HTMLParser.shared.searchClassBlock(html: html,
                                                            className: "js-calendar-graph-svg",
                                                            blockTag: "svg")
        let contributionData = HTMLParser.shared.searchInline(html: classBlock, inlineTag: "rect")
        
        return contributionData
    }
}
