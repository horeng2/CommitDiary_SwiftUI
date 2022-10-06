//
//  ContributionService.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/05.
//

import Foundation
import SwiftUI

class ContributionService: ObservableObject {
    @Published var contributions = [Contribution]()
    @Published var bestCommit = 0
    
    init() {
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        Task {
            await loadContribution(with: userId)
            bestCommitCount()
        }
    }
    
    func loadContribution(with userId: String) async {
        let githubNetwork = GithubNetwork()
        guard let contributions = try? await githubNetwork.getContributions(with: userId) else {
            return
        }
        DispatchQueue.main.async {
            self.contributions = contributions
        }
    }
    
    func bestCommitCount() {
        DispatchQueue.main.async {
            self.bestCommit = self.contributions.map{ $0.commitCount }.max() ?? 0
        }
    }
    
    func continuousCommitCount() {
        
    }

    func setCellsColor(columnsCount: Int) -> [[Color]] {
        guard let lastDate = contributions.last?.date else {
            return []
        }
        let rows = 7
        let blankCellCount = rows - Calendar.current.component(.weekday, from: lastDate)
        
        let cellCount = rows * columnsCount - blankCellCount
        
        let levels = contributions.suffix(cellCount).map{ $0.level }
        var colors = [[Color]]()

        for index in stride(from: 0, to: levels.count, by: rows) {
            let splitedColors = levels[index..<Swift.min(index+rows, levels.count)].map{ $0.color() }
            colors.append(splitedColors)
        }
        return colors
    }
}
