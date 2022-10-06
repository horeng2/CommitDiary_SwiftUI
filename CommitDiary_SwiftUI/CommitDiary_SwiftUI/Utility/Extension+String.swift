//
//  Extension+String.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/05.
//

import Foundation

extension String {
    func stringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertDate = dateFormatter.date(from: self)
        
        return convertDate ?? Date()
    }
    
    func convertDictionary() -> [String: String] {
        let elements = self.components(separatedBy: " ")
            .map{ $0.components(separatedBy: ["\"", "="])
                    .filter{ !$0.isEmpty }
            }
        var htmlElements = [String: String]()
        
        elements.forEach{ element in
            guard let key = element.first,
                  let value = element.last else {
                return
            }
            htmlElements.updateValue(value, forKey: key)
        }
        return htmlElements
    }
}
