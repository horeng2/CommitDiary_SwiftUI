//
//  UserInfo.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

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

extension UserInfo {
    static var empty: UserInfo {
        UserInfo(id: "",
                 name: "",
                 bio: "",
                 profileImageUrl: "",
                 githubUrl: "",
                 blogUrl: "")
    }
    
    static var mock: UserInfo {
        UserInfo(id: "horeng2",
                 name: "김선영",
                 bio: "안녕하세요",
                 profileImageUrl: "https://avatars.githubusercontent.com/u/87305744?v=4",
                 githubUrl: "https://github.com/horeng2",
                 blogUrl: "https://velog.io/@horeng2")
    }
}
