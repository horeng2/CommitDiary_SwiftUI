//
//  Extension+Date.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import Foundation

extension Date {
    func longDateString() -> String {
        let fomatter = DateFormatter()
        fomatter.dateStyle = .long
        return fomatter.string(from: self)
    }
}
