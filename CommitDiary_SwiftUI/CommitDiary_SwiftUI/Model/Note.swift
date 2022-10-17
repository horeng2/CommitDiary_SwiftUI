//
//  Note.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import Foundation

struct Note {
    var id: String
    var title: String
    var date: Date
    var description: String
    var commitCount: Int
    var repositoryName: String
    var commitMessages: String
    
    
    init(commitCount: Int) {
        self.id = UUID().uuidString
        self.title = ""
        self.date = Date()
        self.description = ""
        self.commitCount = commitCount
        self.repositoryName = "선택 없음"
        self.commitMessages = "선택 없음"
    }
}
