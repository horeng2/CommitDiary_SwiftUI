//
//  CommitInfoService.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/16.
//

import Foundation

class CommitInfoService: ObservableObject {
    @Published var commitMessages = [CommitInfo]()
    @Published var repos = [RepoInfo]()

    func loadRepos(from url: String) async {
        let githubNetwork = GithubNetwork()
        guard let token = Keychain.read(key: LoginManager.tokenKey) else {
            return
        }
        guard let repos = try? await githubNetwork.dataRequest(of: RepoRequest(token: token)) else {
            return
        }
        DispatchQueue.main.async {
            self.repos = repos.sorted(by: { $0.updatedDate > $1.updatedDate })
        }
    }
    
    func loadCommits(of repoName: String) async {
        let githubNetwork = GithubNetwork()
        guard let token = Keychain.read(key: LoginManager.tokenKey) else {
            return
        }
        guard let repo = repos.filter({ $0.repoName == repoName }).first else {
            return
        }
        let request = CommitInfoRequest(repo: repo, token: token)
        guard let commitInfos = try? await githubNetwork.dataRequest(of: request) else {
            return
        }
        DispatchQueue.main.async {
            self.commitMessages = commitInfos
        }
    }
}
