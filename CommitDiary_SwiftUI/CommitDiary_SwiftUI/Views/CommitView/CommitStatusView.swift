//
//  CommitStatusView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct CommitStatusView: View {
    @ObservedObject var contributionService: ContributionService
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
            ContributionView(cellsColor: contributionService.setCellsColor(theme: colorTheme, columnsCount: 20))
            todaysCommitView()
            commitHistoryView()
            commitGraphStatusView()
        }
    }
}

extension CommitStatusView {
    private func todaysCommitView() -> some View {
        VStack {
            Text("오늘의 커밋")
            Text("\(contributionService.todaysCommit)회")
        }
    }
    
    private func commitHistoryView() -> some View {
        HStack {
            VStack {
                Text("연속 기록")
                Text("\(contributionService.currentContinuousCommit)일")
            }
            VStack {
                Text("최장 연속 기록")
                Text("연속 \(contributionService.bestContinuousCommit)일")
            }
        }
    }
    
    private func commitGraphStatusView() -> some View {
        VStack {
            commitGraphView()
            HStack{
                Text("0일")
                Spacer()
                Text("\(contributionService.bestContinuousCommit)일")
            }
        }
        .padding(.horizontal, 30)
    }
    
    private func commitGraphView() -> some View {
        ZStack(alignment: .leading) {
            let graphWidth: CGFloat = 200
            let currentContinuousCommit = CGFloat(contributionService.currentContinuousCommit)
            let bestContinuousCommit = CGFloat(contributionService.bestContinuousCommit)
            Rectangle()
                .frame(width: currentContinuousCommit / bestContinuousCommit * graphWidth,
                       height: 20,
                       alignment: .leading)
                .foregroundColor(.red)
            Rectangle()
                .stroke(.black, lineWidth: 2)
                .frame(height: 20,  alignment: .leading)
        }
    }
}

//struct CommitStatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommitStatusView()
//    }
//}
