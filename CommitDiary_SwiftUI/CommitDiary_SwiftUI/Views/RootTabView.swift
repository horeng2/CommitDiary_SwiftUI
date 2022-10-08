//
//  ContentView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct RootTabView: View {
    @State var index = ViewIndex.commitStatusView.index
    @AppStorage(LoginManager.isLoginKey)
    var isLogin = UserDefaults.standard.bool(forKey: LoginManager.isLoginKey) == true
    @ObservedObject var contributionService: ContributionService
    @ObservedObject var userInfoService: UserInfoService
    
    var body: some View {
        if contributionService.contributions.isEmpty {
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
            CommitStatusView(contributionService: contributionService)
                .tabItem {
                    Image(systemName: "flame")
                    Text("Today")
                }
            NoteListView()
                .tabItem {
                    Image(systemName: "crown")
                    Text("Note")
                }
            SettingView(userInfo: $userInfoService.userInfo
            )
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootTabView()
//    }
//}
