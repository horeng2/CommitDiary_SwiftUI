//
//  ContentView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct RootTabView: View {
    @State var index = ViewIndex.commitStatusView.index
    @State var isLogin = false
    
    var body: some View {
        if isLogin {
            rootTabView()
        } else {
            loginView()
        }
    }
}

extension RootTabView {
    private func rootTabView() -> some View {
        TabView(selection: $index) {
            CommitStatusView()
                .tabItem {
                    Image(systemName: "flame")
                    Text("Today")
                }
            NoteListView()
                .tabItem {
                    Image(systemName: "crown")
                    Text("Note")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
        }
    }
    
    private func loginView() -> some View {
        Link(destination: LoginManager.shared.requestCode()) {
            Text("로그인")
        }
        .onOpenURL { url in
            let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
            LoginManager.shared.requestAccessToken(with: code)
            isLogin = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
