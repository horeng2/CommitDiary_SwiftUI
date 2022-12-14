//
//  Contribution.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/05.
//

import Foundation
import SwiftUI

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

extension Contribution {
    static var empty: Contribution {
        Contribution(
            date: Date(),
            commitCount: 0,
            level: .zero
        )
    }
}

enum CommitLevel: Int, CaseIterable {
    case zero
    case one
    case two
    case three
    case four
}
