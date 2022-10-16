//
//  CommitInfo.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/16.
//

import Foundation

struct CommitInfo: Decodable {
    let items: CommitInfoItem

    private enum CodingKeys: String, CodingKey {
        case items
    }
    
    struct CommitInfoItem: Decodable {
        let comment: String
        let createdDate: String
        
        private enum CodingKeys: String, CodingKey {
            case comment = "title"
            case createdDate = "created_at"
        }
    }
}
