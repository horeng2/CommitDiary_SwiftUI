//
//  RepoInfos.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/16.
//

import Foundation

struct RepoInfos: Decodable {
    let repos: [Repo]
    
    struct Repo: Decodable {
        let name: String
        let commitsUrl: String
        
        private enum CodingKeys: String, CodingKey {
            case name = "name"
            case commitsUrl = "commits_url"
        }
    }
}
