//
//  SettingView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct SettingView: View {
    @State var settingList = ["pink", "blue", "green", "yellow", "black"]
    var body: some View {
        NavigationView {
            content
                .navigationTitle("설정")
        }
    }
    
    private var content: some View {
        VStack {
            settingListView()
        }
    }
}

extension SettingView {
    private func userInfoView() -> some View {
        VStack {
            Image(systemName: "flame")
            Text("김선영")
            Text("horeng2")
        }
    }
    
    private func settingListView() -> some View {
        List {
            userInfoView()
            Section {
                ForEach(settingList, id: \.self) { color in
                    settingRow(text: color)
                }
            } header: {
                Text("컬러")
            }
            Section {
                settingRow(text: "move to github")
            } header: {
                Text("이동")
            }
            Section {
                settingRow(text: "로그아웃", color: .red)
            }
        }
    }
    
    private func settingRow(text: String, color: Color? = nil) -> some View {
        Text(text)
            .foregroundColor(color)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
