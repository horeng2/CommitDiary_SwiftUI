//
//  CommitChart.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/05.
//

import SwiftUI

struct CommitChart<Index: View>: View {
    let rows = 7
    let columns: Int
    let spacing: CGFloat
    let index: (Int, Int) -> Index
    
    var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            ForEach(0..<columns, id: \.self) { row in
                VStack(alignment: .center, spacing: spacing) {
                    ForEach(0..<rows, id: \.self) { column in
                        index(column, row)
                    }
                }
            }
        }
    }
    
    init(columns: Int, spacing: CGFloat, @ViewBuilder index: @escaping (Int, Int) -> Index) {
        self.columns = columns
        self.spacing = spacing
        self.index = index
    }
}
