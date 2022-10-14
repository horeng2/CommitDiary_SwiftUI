//
//  htmlParser.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/05.
//

import Foundation

struct HTMLParser {
    static var shared = HTMLParser()
    
    private func parseInline(html: [String], inlineType: String) -> [Contribution] {
        let dateKey = "data-date"
        let commitCountKey = "data-count"
        let levelKey = "data-level"
        
        let htmlElements = html.map{ $0.convertDictionary() }
        let contributions =  htmlElements
            .map { inline -> Contribution in
                guard let date = inline[dateKey],
                      let commitCount = inline[commitCountKey],
                      let level = inline[levelKey] else {
                    return Contribution.empty
                }
                return Contribution(date: date.stringToDate(),
                                    commitCount: Int(commitCount) ?? 0,
                                    level: CommitLevel(rawValue: Int(level) ?? 0) ?? .zero)
            }
        return contributions.sorted{ $0.date < $1.date }
    }
    
    func searchClassBlock(html: String, className: String, blockTag: String) -> String {
        var searchingPoint = html.startIndex
        let searchingRange = html[searchingPoint..<html.endIndex]
        
        guard let startTagIndex = searchingRange.range(of: className),
              let endTagIndex = searchingRange.range(of: "></\(blockTag)>") else {
            return ""
        }
        
        let startIndexOfBlock = html[startTagIndex].startIndex
        let endIndexOfBlock = html[endTagIndex].startIndex
        
        let searchedBlock = html[startIndexOfBlock..<endIndexOfBlock]
        searchingPoint = html[endTagIndex].endIndex
                
        return String(searchedBlock)
    }
    
    func searchInline(html: String, inlineTag: String) -> [Contribution] {
        var inlines = [String]()
        var searchingPoint = html.startIndex
        
        while searchingPoint < html.endIndex {
            let searchingRange = html[searchingPoint..<html.endIndex]
            
            guard let startTagIndex = searchingRange.range(of: "\(inlineTag)"),
                  let endTagIndex = searchingRange.range(of: "></\(inlineTag)>") else {
                return parseInline(html: inlines, inlineType: inlineTag)
            }
            
            let classStartIndex = html[startTagIndex].endIndex
            let classEndIndex = html[endTagIndex].startIndex
            
            let searchedInline = html[classStartIndex..<classEndIndex]
            searchingPoint = html[endTagIndex].endIndex
            
            inlines.append(String(searchedInline))
        }
        return parseInline(html: inlines, inlineType: inlineTag)
    }
}

enum HTMLError: Error {
    case classInputError
    case inlineInputError
    case encodingError
}
