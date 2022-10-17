//
//  SettingView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.openURL) var openURL
    @State var tapColorThemeButton = false
    @State var tapLogoutButton = false
    @Binding var userInfo: UserInfo
    @Binding var profilImage: UIImage
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
    private func settingListView() -> some View {
        List {
            userInfoView()
            Section {
                ForEach(Theme.allCases, id: \.self) { theme in
                    pickColorButtonView(theme: theme)
                        .listRowBackground(colorTheme.viewBackground)
                }
            } header: {
                Text("테마 색상")
            }
            Section {
                moveButtonView()
                    .listRowBackground(colorTheme.viewBackground)
            } header: {
                Text("이동")
            }
            Section {
                logoutButtonView()
                    .listRowBackground(colorTheme.viewBackground)
                    .onTapGesture {
                        LoginManager.shared.logout()
                    }
            }
        }
        .font(.system(.body, design: .monospaced))
        .foregroundColor(.black)
    }
    
    private func userInfoView() -> some View {
        HStack {
            Image(uiImage: profilImage)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 50))
            
            VStack(alignment: .leading) {
                Text(userInfo.name)
                    .fontWeight(.bold)
                Text(userInfo.id)
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
        }
    }
    
    private func pickColorButtonView(theme: Theme) -> some View {
        Button(theme.rawValue) {
            tapColorThemeButton = true
            colorTheme = theme
            UserDefaults.standard.set(theme.rawValue, forKey: "theme")
        }
        .alert("테마가 변경되었습니다!", isPresented: $tapColorThemeButton) {}
    }
    
    private func moveButtonView() -> some View {
        Button("Github로 이동") {
            openURL(URL(string: userInfo.githubUrl)!)
        }
    }
    
    private func logoutButtonView() -> some View {
        Button("로그아웃") {
            tapLogoutButton = true
        }
        .foregroundColor(.red)
        .alert("로그아웃 하시겠습니까?", isPresented: $tapLogoutButton) {
            Button("취소", role: .cancel) {}
            Button("확인", role: .destructive) {
                UserDefaults.standard.set(false, forKey: LoginManager.isLoginKey)
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(userInfo: .constant(UserInfo.mock), profilImage: .constant(UIImage(systemName: "person")!), colorTheme: .constant(.defaultGreen))
    }
}
