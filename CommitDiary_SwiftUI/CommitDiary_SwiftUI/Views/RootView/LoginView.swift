//
//  LoginView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/11.
//

import SwiftUI
import SafariServices

struct LoginView: View {
    @Environment(\.openURL) private var openURL
    @State private var showSafari = false

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
                showSafari = true
            } label: {
                HStack(spacing: 0 ) {
                    Image("github")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(5)
                    Text("Github 계정으로 시작하기")
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .padding(10)
                }
                .background(Color.black)
                .cornerRadius(5)
                .padding(.bottom, 80)
            }
            .popover(isPresented: $showSafari) {
                SafariView()
                    .onOpenURL { temporaryCode in
                        Task{
                            await LoginManager.shared.login(with: temporaryCode)
                        }
                    }
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return SFSafariViewController(url: LoginManager.shared.loginUrl)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        return
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
