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
    @State var index = ViewIndex.commitStatusView.index
    
    
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
        TabView(selection: $index) {
            CommitStatusView(colorTheme: $colorTheme)
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Today")
                }
                .tag(ViewIndex.commitStatusView.index)
            NoteListView()
                .tabItem {
                    Image(systemName: "magazine")
                    Text("Note")
                }
                .tag(ViewIndex.noteListView.index)
            SettingView(
                userInfo: $userInfoService.userInfo,
                colorTheme: $colorTheme
            )
            .tabItem {
                Image(systemName: "gear")
                Text("Setting")
            }
            .tag(ViewIndex.settingView.index)
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
