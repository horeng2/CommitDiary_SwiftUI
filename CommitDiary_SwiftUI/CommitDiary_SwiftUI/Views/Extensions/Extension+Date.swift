//
//  Extension+Date.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import Foundation

extension Date {
    func toString() -> String {
        let fomatter = DateFormatter()
        fomatter.dateFormat = "yyyy-MM-dd   HH:mm"
        return fomatter.string(from: self)
    }
}
