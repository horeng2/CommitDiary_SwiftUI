//
//  CommitDiary_SwiftUIApp.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

@main
struct CommitDiary_SwiftUIApp: App {
    @AppStorage(LoginManager.isLoginKey) var isLogin = false
    @AppStorage("theme") var colorTheme = Theme.defaultGreen
    
    @StateObject var userInfoService = UserInfoService()
    @StateObject var contributionService = ContributionService()
    @StateObject var commitInfoService = CommitInfoService()
    let coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            if isLogin {
                RootTabView(colorTheme: $colorTheme)
                    .environment(\.managedObjectContext, coreDataStack.context)
                    .environmentObject(userInfoService)
                    .environmentObject(contributionService)
                    .environmentObject(commitInfoService)
                    .task {
                        await userInfoService.loadUserInfo()
                        await commitInfoService.loadRepos(from: userInfoService.userInfo.reposUrl)
                        await contributionService.loadContribution()
                    }
                
            } else {
                LoginView()
            }
        }
    }
}
