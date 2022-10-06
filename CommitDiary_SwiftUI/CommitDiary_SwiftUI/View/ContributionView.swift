//
//  ContributionView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/07.
//

import SwiftUI

struct ContributionView: View {
    let cellsColor: [[Color]]

    var body: some View {
            CommitChart(columns: 20, spacing: 3.0) { row, column in
                if row >= cellsColor[column].count {
                    Color("background").modifier(ContributionCell())
                } else {
                    cellsColor[column][row].modifier(ContributionCell())
                }
            }
            .frame(height: 120)
            .padding()
    }
}

struct ContributionCell: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .stroke(Color.clear, lineWidth: 1.0)
            )
            .cornerRadius(1.0)
    }
}
