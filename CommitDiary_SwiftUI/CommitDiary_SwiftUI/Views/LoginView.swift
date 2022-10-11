//
//  LoginView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/11.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.openURL) var openURL
    @State var device = MTLCreateSystemDefaultDevice()
    var body: some View {
        VStack {
            Spacer()
            titleView()
            Spacer()
            loginButtonView()
        }
    }
}

extension LoginView {
    private func titleView() -> some View {
        VStack(alignment: .center) {
            Image(systemName: "leaf.fill")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(Color.green)
            Text("Commit Diary")
                .font(.system(size: 50, weight: .bold, design: .rounded))
            Text("잔디 일기")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(Color.gray)
        }
    }
    
    private func loginButtonView() -> some View {
        VStack {
            Text("앱을 사용하려면 GitHub 계정 로그인이 필요합니다.")
                .foregroundColor(Color.gray)
            Button {
                openURL(LoginManager.shared.loginUrl)
            } label: {
                HStack(spacing: 0 ) {
                    Image("github")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(5)
                    Text("GitHub 계정으로 시작하기")
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .padding(10)
                }
                .background(Color.black)
                .cornerRadius(5)
                .padding(.bottom, 80)
            }
            .onOpenURL { temporaryCode in
                LoginManager.shared.login(with: temporaryCode)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
