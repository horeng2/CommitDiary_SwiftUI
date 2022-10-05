//
//  Contribution.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/05.
//

import Foundation

struct Contribution {
    let date: Date
    let commitCount: Int
    let level: CommitLevel
    
    init(date: Date, commitCount: Int, level: CommitLevel) {
        self.date = date
        self.commitCount = commitCount
        self.level = level
    }
}

enum CommitLevel: Int, CaseIterable {
    case zero
    case one
    case two
    case three
    case four
}
