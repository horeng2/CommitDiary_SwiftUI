//
//  NetworkError.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

import Foundation

enum NetworkError: Error {
    case parsingError(type: String)
    case statusCodeError(code: String)
    case invaildData
}
