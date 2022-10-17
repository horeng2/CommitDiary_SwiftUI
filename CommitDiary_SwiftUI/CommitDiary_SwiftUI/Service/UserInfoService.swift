//
//  UserInfoService.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

import Foundation
import SwiftUI

class UserInfoService: ObservableObject {
    @Published var userInfo = UserInfo.empty
    @Published var profilImage = UIImage()
    
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
            self.loadProfilImage(url: info.profileImageUrl)
        }
    }
    
    func loadProfilImage(url: String) {
        guard let imageUrl = URL(string: url),
              let data = try? Data(contentsOf: imageUrl),
              let image = UIImage(data: data) else {
            return
        }
        DispatchQueue.main.async {
            self.profilImage = image
        }
    }
}
