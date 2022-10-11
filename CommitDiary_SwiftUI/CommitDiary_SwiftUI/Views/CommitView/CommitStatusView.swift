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
            todaysCommitView()
            Spacer()
            currentContinuousCommitView()
            Spacer()
            bestContinuousCommitView()
            Spacer()
            commitGraphStatusView()
            Spacer()
        }
    }
}

extension CommitStatusView {
    private func contributionView() -> some View {
        VStack {
            HStack {
                Text("CONTRIBUTIONS")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Spacer()
            }
            ContributionView(cellsColor: contributionService.setCellsColor(theme: colorTheme, columnsCount: 20))
        }
        .padding(.top, 30)
    }
    
    private func todaysCommitView() -> some View {
        VStack {
            Text("오늘의 커밋")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.gray)
            Text("\(contributionService.todaysCommit)회")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.black)
        }
    }
    
    private func currentContinuousCommitView() -> some View {
        VStack {
            Text("연속 기록")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.gray)
            Text("\(contributionService.currentContinuousCommit)일")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.black)
        }
        
    }
    
    private func bestContinuousCommitView() -> some View {
        VStack {
            Text("최장 연속 기록")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.gray)
            Text("연속 \(contributionService.bestContinuousCommit)일")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.black)
        }
    }
    
    private func commitGraphStatusView() -> some View {
        VStack {
            commitGraphView()
            HStack{
                Text("0일")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
                Text("\(contributionService.bestContinuousCommit)일")
                    .font(.system(size: 20, weight: .medium))
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
                .frame(width: currentContinuousCommit / bestContinuousCommit * graphWidth,
                       height: 20,
                       alignment: .leading)
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
