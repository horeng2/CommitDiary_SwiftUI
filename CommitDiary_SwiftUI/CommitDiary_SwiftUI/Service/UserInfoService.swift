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
        let githubNetwork = GithubNetwork()
        guard let token = Keychain.read(key: LoginManager.tokenKey),
              let info = try? await githubNetwork.dataRequest(of: UserInfoRequest(token: token)) else {
            return
        }
        
        if LoginManager.shared.isLogin == false {
            UserDefaults.standard.set(info.id, forKey: "userId")
        }
        
        DispatchQueue.main.async {
            self.userInfo = info
            self.loadProfilImage(url: "https://avatars.githubusercontent.com/u/87305744?v=4")
        }
    }
    
    private func loadProfilImage(url: String) {
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
