//
//  Note.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import Foundation

struct Note {
    var id: UUID
    var title: String
    var date: Date
    var description: String
    var commitCount: Int
    
    
    init(commitCount: Int) {
        self.id = UUID()
        self.title = ""
        self.date = Date()
        self.description = ""
        self.commitCount = commitCount
    }
}
