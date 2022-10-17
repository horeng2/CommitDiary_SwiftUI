//
//  ContentView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var contributionService: ContributionService
    @Binding var colorTheme: Theme
    
    var body: some View {
        if contributionService.contributions.isEmpty {
            progressView()
        } else {
            tabView()
        }
    }
}

extension RootTabView {
    private func tabView() -> some View {
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
            SettingView(colorTheme: $colorTheme)
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
        RootTabView(colorTheme: .constant(Theme.blue))
            .environmentObject(contriburionService)
            .environmentObject(userInfoService)
    }
}
