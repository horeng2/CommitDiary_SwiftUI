//
//  APIRequest.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/16.
//

import Foundation

protocol APIRequest {
    associatedtype ResponseType: Decodable
    
    var token: String { get }
    var url: URL? { get }
    var urlRequest: URLRequest? { get }
}
