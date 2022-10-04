//
//  SettingView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct SettingView: View {
    @State var settingList = [Color.red, Color.blue, Color.green, Color.yellow, Color.black]
    var body: some View {
        NavigationView {
            content
        }
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack {
            settingListView()
                .navigationTitle("설정")
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
                    pickColorButtonView(color: color)
                }
            } header: {
                Text("컬러")
            }
            Section {
                moveButtonView()
            } header: {
                Text("이동")
            }
            Section {
                logoutButtonView()
                    .onTapGesture {
                        LoginManager.shared.logout()
                    }
            }
        }
    }
    
    private func pickColorButtonView(color: Color) -> some View {
        Button {
            print(color)
        } label: {
            Text(color.description)
                .foregroundColor(.black)
        }
    }
    
    private func moveButtonView() -> some View {
        Button {
            print("move")
        } label: {
            Text("move to github")
                .foregroundColor(.black)
        }
    }
    
    private func logoutButtonView() -> some View {
        Button {
            UserDefaults.standard.set(false, forKey: LoginManager.isLoginKey)
        } label: {
            Text("로그아웃")
                .foregroundColor(.red)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
