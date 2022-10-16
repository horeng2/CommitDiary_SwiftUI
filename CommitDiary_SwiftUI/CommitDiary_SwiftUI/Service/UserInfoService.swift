//
//  UserInfoService.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

import Foundation

class UserInfoService: ObservableObject {
    @Published var userInfo = UserInfo.empty
    
    func loadUserInfo() async {
        guard let token = Keychain.read(key: LoginManager.tokenKey) else {
            return
        }
        let githubNetwork = GithubNetwork()
        guard let info = try? await githubNetwork.dataRequest(of: UserInfoRequest(token: token)) else {
            return
        }
        DispatchQueue.main.async {
            self.userInfo = info
            UserDefaults.standard.set(info.id, forKey: "userId")
        }
    }
}
