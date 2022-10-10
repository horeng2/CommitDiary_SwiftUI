//
//  SettingView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.openURL) var openURL
    @Binding var userInfo: UserInfo
    @State var settingList = [Color.red, Color.blue, Color.green, Color.yellow, Color.black]
    @State var showingMoveGithubAlert = false
    @Binding var index: Int
    @Binding var colorTheme: Theme
    
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
        HStack {
            AsyncImage(url: URL(string: userInfo.profileImageUrl)) { image in
                image.resizable()
            } placeholder: {
                Color.white
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            VStack{
                Text(userInfo.name)
                Text(userInfo.id)
            }
        }
    }
    
    private func settingListView() -> some View {
        List {
            userInfoView()
            Section {
                ForEach(Theme.allCases, id: \.self) { theme in
                    pickColorButtonView(theme: theme)
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
    
    private func pickColorButtonView(theme: Theme) -> some View {
        Button {
            colorTheme = theme
            UserDefaults.standard.set(theme.rawValue, forKey: "theme")
        } label: {
            Text(theme.rawValue)
                .foregroundColor(.black)
        }
    }
    
    private func moveButtonView() -> some View {
        Button("move to github") {
            showingMoveGithubAlert = true
            index = ViewIndex.settingView.index
        }
        .foregroundColor(.black)
        .alert("이동하시겠습니까?", isPresented: $showingMoveGithubAlert) {
            Button("취소", role: .cancel) {}
            Button("이동", role: .destructive) {
                openURL(URL(string: userInfo.githubUrl)!)
            }
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

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView(userInfo: .constant(UserInfo.mock))
//    }
//}
