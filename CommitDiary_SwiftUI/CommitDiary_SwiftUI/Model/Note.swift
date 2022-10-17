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
    var noteDescription: String
    var commitCount: Int
    var repositoryName: String
    var commitMessage: String
    
    
    init(commitCount: Int) {
        self.id = UUID().uuidString
        self.title = ""
        self.date = Date()
        self.noteDescription = ""
        self.commitCount = commitCount
        self.repositoryName = "선택해주세요."
        self.commitMessage = "선택해주세요."
    }
}
