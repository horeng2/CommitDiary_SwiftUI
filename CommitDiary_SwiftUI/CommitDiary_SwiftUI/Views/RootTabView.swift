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
    @ObservedObject var contributionService: ContributionService
    @ObservedObject var userInfoService: UserInfoService
    @State var index = ViewIndex.commitStatusView.index
    
    
    var body: some View {
        if contributionService.contributions.isEmpty && isLogin {
            Text("로딩뷰")
        } else if isLogin {
            rootTabView()
        } else {
            loginView()
        }
    }
}

extension RootTabView {
    private func rootTabView() -> some View {
        TabView(selection: $index) {
            CommitStatusView(contributionService: contributionService, colorTheme: $colorTheme)
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Today")
                }
            NoteListView(contributionService: contributionService)
                .tabItem {
                    Image(systemName: "magazine")
                    Text("Note")
                }
            SettingView(userInfo: $userInfoService.userInfo, index: $index, colorTheme: $colorTheme)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
                .tag(ViewIndex.settingView.index)
        }
    }
    
    private func loginView() -> some View {
        Link(destination: LoginManager.shared.loginUrl) {
            Text("로그인")
        }
        .onOpenURL { temporaryCode in
            LoginManager.shared.login(with: temporaryCode)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let contributionService = ContributionService()
        let userInfoservice = UserInfoService()
        RootTabView(contributionService: contributionService, userInfoService: userInfoservice)
    }
}
