//
//  CommitStatusView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct CommitStatusView: View {
    @EnvironmentObject private var contributionService: ContributionService
    @State private var isLoding = false
    @Binding var colorTheme: Theme
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("활동")
                .toolbar {
                    refreshButtonView()
                }
        }
        .navigationViewStyle(.stack)
        .padding(.bottom)
    }
    
    private var content: some View {
        VStack {
            contributionView()
            Spacer()
            Text("오늘의 커밋")
                .logContent {
                    Text("\(contributionService.todaysCommit)회")
                }
            Spacer()
            Text("연속 기록")
                .logContent {
                    Text("\(contributionService.currentContinuousCommit)일")
                }
            Spacer()
            Text("최장 연속 기록")
                .logContent {
                    Text("\(contributionService.bestContinuousCommit)일")
                }
            Spacer()
            commitGraphStatusView()
        }
    }
}

extension CommitStatusView {
    private func refreshButtonView() -> some View {
        Button {
            isLoding = true
            Task{
                try await Task.sleep(nanoseconds: 800_000_000)
                await contributionService.loadContribution()
                isLoding = false
            }
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath").opacity(isLoding ? 0.5 : 1)
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .rotationEffect(.degrees(isLoding ? 360 : 0))
                .scaleEffect(isLoding ? 1.5 : 1)
                .padding()
                .animation(.spring(), value: isLoding)
        }
        .disabled(isLoding)
    }
    
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
 
    private func commitGraphStatusView() -> some View {
        VStack {
            commitGraphView()
            HStack{
                Text("\(0)일")
                    .font(.system(.title3, design: .monospaced))
                    .foregroundColor(.gray)
                Spacer()
                Text("\(contributionService.bestContinuousCommit)일")
                    .font(.system(.title3, design: .monospaced))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
    
    private func commitGraphView() -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .stroke(.black, lineWidth: 2)
                .frame(height: 20,  alignment: .leading)
            
            if contributionService.currentContinuousCommit > 0 {
                let graphWidth: CGFloat = 200
                let currentContinuousCommit = CGFloat(contributionService.currentContinuousCommit)
                let bestContinuousCommit = CGFloat(contributionService.bestContinuousCommit)
                Rectangle()
                    .frame(
                        width: graphWidth / bestContinuousCommit * currentContinuousCommit,
                        height: 20,
                        alignment: .leading
                    )
                    .foregroundColor(colorTheme.levelfourColor)
            }
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
