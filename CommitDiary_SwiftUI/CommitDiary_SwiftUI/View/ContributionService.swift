//
//  ContributionService.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/05.
//

import Foundation

class ContributionService: ObservableObject {
    @Published var contributions = [Contribution]()
    var userId: String
    
    init() {
        self.userId = ""
    }
    
    func loadContriburion() async {
        let githubNetwork = GithubNetwork()
        guard let contributions = try? await githubNetwork.getContributions(with: self.userId) else {
            return
        }
        DispatchQueue.main.async {
            self.contributions = contributions
        }
    }
}
