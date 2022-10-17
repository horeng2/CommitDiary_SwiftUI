//
//  ContentView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct RootTabView: View {
    @AppStorage(LoginManager.isLoginKey)
    var isLogin = UserDefaults.standard.bool(forKey: LoginManager.isLoginKey) == true
    @AppStorage("theme")
    var colorTheme = Theme(rawValue: UserDefaults.standard.string(forKey: "theme") ?? "") ?? .defaultGreen
    @EnvironmentObject var contributionService: ContributionService
    @EnvironmentObject var userInfoService: UserInfoService
    
    var body: some View {
        if contributionService.contributions.isEmpty && isLogin {
            progressView()
        } else if isLogin {
            rootTabView()
        } else {
            LoginView()
        }
    }
}

extension RootTabView {
    private func rootTabView() -> some View {
        TabView {
            CommitStatusView(colorTheme: $colorTheme)
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Today")
                }
            NoteListView(colorTheme: $colorTheme)
                .tabItem {
                    Image(systemName: "magazine")
                    Text("Note")
                }
            SettingView(
                userInfo: $userInfoService.userInfo,
                profilImage: $userInfoService.profilImage,
                colorTheme: $colorTheme
            )
            .tabItem {
                Image(systemName: "gear")
                Text("Setting")
            }
        }
        .accentColor(colorTheme.levelThreeColor)
        .onAppear{
            UITableView.appearance().backgroundColor = .clear
        }
    }
    
    private func progressView() -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let contriburionService = ContributionService()
        let userInfoService = UserInfoService()
        RootTabView()
            .environmentObject(contriburionService)
            .environmentObject(userInfoService)
    }
}
