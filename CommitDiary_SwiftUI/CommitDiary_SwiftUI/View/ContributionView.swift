//
//  ContributionView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/07.
//

import SwiftUI

struct ContributionView: View {
    let colorCells: [[Color]]

    var body: some View {
            CommitChart(columns: 20, spacing: 3.0) { row, column in
                if row >= colorCells[column].count {
                    Color("background").modifier(CalendarChartCell())
                } else {
                    colorCells[column][row].modifier(CalendarChartCell())
                }
            }
            .frame(height: 120)
            .padding()
    }
}

struct CalendarChartCell: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .stroke(Color.clear, lineWidth: 1.0)
            )
            .cornerRadius(1.0)
    }
}
