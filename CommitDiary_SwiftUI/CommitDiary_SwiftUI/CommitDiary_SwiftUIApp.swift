//
//  CommitDiary_SwiftUIApp.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

@main
struct CommitDiary_SwiftUIApp: App {
    @AppStorage(LoginManager.isLoginKey) private var isLogin = false
    @AppStorage("theme") private var colorTheme = Theme.defaultGreen
    
    @StateObject private var userInfoService = UserInfoService()
    @StateObject private var contributionService = ContributionService()
    @StateObject private var commitInfoService = CommitInfoService()
    private let coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            if isLogin {
                RootTabView(isLogin: $isLogin, colorTheme: $colorTheme)
                    .environment(\.managedObjectContext, coreDataStack.context)
                    .environmentObject(userInfoService)
                    .environmentObject(contributionService)
                    .environmentObject(commitInfoService)
                    .task(priority: .high) {
                        await userInfoService.loadUserInfo()
                        await contributionService.loadContribution()
                    }
                    .task {
                        await commitInfoService.loadRepos(from: userInfoService.userInfo.reposUrl)
                    }
            } else {
                LoginView()
            }
        }
    }
}
