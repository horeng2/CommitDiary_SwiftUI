//
//  CommitInfo.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/16.
//

import Foundation

struct CommitInfo: Decodable, Identifiable {
    let id = UUID()
    let infoItmes: CommitInfoItem

    private enum CodingKeys: String, CodingKey {
        case infoItmes = "commit"
    }

    struct CommitInfoItem: Decodable {
        let author: Author
        let message: String
    }
    
    struct Author: Decodable {
        let date: String
    }
}
