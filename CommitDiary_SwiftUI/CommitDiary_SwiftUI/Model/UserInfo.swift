//
//  UserInfo.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

import Foundation

import Foundation

struct UserInfo: Decodable {
    let id: String
    let name: String
    let bio: String
    let profileImageUrl: String
    let githubUrl: String
    let blogUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "login"
        case name
        case bio
        case profileImageUrl = "avatar_url"
        case githubUrl = "html_url"
        case blogUrl = "blog"
    }
}
