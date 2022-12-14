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
    @Published var todaysCommit = 0
    @Published var currentContinuousCommit = 0
    @Published var bestContinuousCommit = 0
    
    func loadContribution(userId: String) async {
        let githubNetwork = GithubNetwork()
        guard let contributions = try? await githubNetwork.getContributions(with: userId) else {
            return
        }
        DispatchQueue.main.async {
            self.contributions = contributions
            self.todaysCommitCount()
            self.continuousCommitCount()
        }
    }
    
    private func todaysCommitCount() {
        DispatchQueue.main.async {
            self.todaysCommit = self.contributions.last?.commitCount ?? 0
        }
    }
    
    private func continuousCommitCount() {
        DispatchQueue.main.async {
            let continuousGroup = self.contributions
                .map{ String($0.level.rawValue) }
                .joined()
                .split(separator: "0")
            self.bestContinuousCommit = continuousGroup.map{ $0.count }.max() ?? 0
            
            if self.contributions.last?.commitCount == 0 {
                self.currentContinuousCommit = 0
            } else {
                self.currentContinuousCommit = continuousGroup.last?.count ?? 0
            }
        }
    }

    func setCellsColor(theme: Theme, columnsCount: Int) -> [[Color]] {
        guard let lastDate = contributions.last?.date else {
            return []
        }
        let rows = 7
        let blankCellCount = rows - Calendar.current.component(.weekday, from: lastDate)
        let cellCount = rows * columnsCount - blankCellCount
        let levels = contributions.suffix(cellCount).map{ $0.level }
        
        var colors = [[Color]]()
        for index in stride(from: 0, to: levels.count, by: rows) {
            let splitedColors = levels[index..<Swift.min(index+rows, levels.count)]
                .map{ theme.colorSet(by: $0) }
            colors.append(splitedColors)
        }
        return colors
    }
}
