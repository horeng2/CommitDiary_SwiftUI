//
//  CommitStatusView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct CommitStatusView: View {
    var body: some View {
        NavigationView {
            content
                .navigationTitle("활동")
        }
    }
    
    private var content: some View {
        VStack {
            todaysCommitView()
            commitHistoryView()
            commitGraphStatusView()
        }
    }
}

extension CommitStatusView {
    func todaysCommitView() -> some View {
        VStack {
            Text("오늘의 커밋")
            Text("19회")
        }
    }
    
    func commitHistoryView() -> some View {
        HStack {
            VStack {
                Text("연속기록")
                Text("7일")
            }
            VStack {
                Text("최고기록")
                Text("연속12일")
            }
        }
    }
    
    func commitGraphStatusView() -> some View {
        VStack {
            commitGraphView()
            HStack{
                Text("0일")
                Spacer()
                Text("12일")
            }
        }
        .padding(.horizontal, 30)
    }
    
    func commitGraphView() -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .stroke(.black, lineWidth: 3)
                .frame(height: 20, alignment: .leading)
            Rectangle()
                .background(.red)
                .frame(width: 200, height: 20,  alignment: .leading)
        }
    }
}

struct CommitStatusView_Previews: PreviewProvider {
    static var previews: some View {
        CommitStatusView()
    }
}
