//
//  CommitStatusView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct CommitStatusView: View {
    @EnvironmentObject var contributionService: ContributionService
    @Binding var colorTheme: Theme
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("활동")
        }
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack {
            contributionView()
            Spacer()
            logView(title: "오늘의 커밋", log: "\(contributionService.todaysCommit)회")
            Spacer()
            logView(title: "연속 기록", log: "\(contributionService.currentContinuousCommit)일")
            Spacer()
            logView(title: "최장 연속 기록", log: "연속 \(contributionService.bestContinuousCommit)일")
            Spacer()
            commitGraphStatusView()
            Spacer()
        }
    }
}

extension CommitStatusView {
    private func contributionView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("CONTRIBUTIONS")
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(.gray)
                .padding(.horizontal)
            let cellsColor = contributionService.setCellsColor(
                theme: colorTheme,
                columnsCount: 20
            )
            ContributionView(cellsColor: cellsColor)
        }
        .padding(.top, 30)
    }
    
    private func logView(title: String, log: String) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(.title2, design: .monospaced))
                .foregroundColor(.gray)
            Text(log)
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.medium)
                .foregroundColor(.black)
        }
    }
    
    private func commitGraphStatusView() -> some View {
        VStack {
            commitGraphView()
            HStack{
                Text("0일")
                    .font(.system(.title2, design: .monospaced))
                    .foregroundColor(.gray)
                Spacer()
                Text("\(contributionService.bestContinuousCommit)일")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
    
    private func commitGraphView() -> some View {
        ZStack(alignment: .leading) {
            let graphWidth: CGFloat = 200
            let currentContinuousCommit = CGFloat(contributionService.currentContinuousCommit)
            let bestContinuousCommit = CGFloat(contributionService.bestContinuousCommit)
            Rectangle()
                .frame(
                    width: currentContinuousCommit / bestContinuousCommit * graphWidth,
                    height: 20,
                    alignment: .leading
                )
                .foregroundColor(colorTheme.levelfourColor)
            Rectangle()
                .stroke(.black, lineWidth: 2)
                .frame(height: 20,  alignment: .leading)
        }
    }
}

struct CommitStatusView_Previews: PreviewProvider {
    static let contriburionService = ContributionService()

    static var previews: some View {
        CommitStatusView(colorTheme: .constant(Theme.defaultGreen))
            .environmentObject(contriburionService)
    }
}
