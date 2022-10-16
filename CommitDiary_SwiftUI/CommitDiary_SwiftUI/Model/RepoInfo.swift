//
//  RepoInfo.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/16.
//

import Foundation

struct RepoInfo: Decodable, Identifiable {
    var id = UUID()
    let owner: Owner
    let repoName: String
    let updatedDate: String
    
    private enum CodingKeys: String, CodingKey {
        case owner
        case repoName = "name"
        case updatedDate = "updated_at"
    }
    
    struct Owner: Decodable {
        let name: String
        
        private enum CodingKeys: String, CodingKey {
            case name = "login"
        }
    }
}
