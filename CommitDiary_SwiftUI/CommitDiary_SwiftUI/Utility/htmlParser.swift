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

//기능 구현 뒤 시도해볼 코드

//let blockTags: [String] = [
//    "html", "head", "body", "frameset", "script", "noscript", "style", "meta", "link", "title", "frame",
//    "noframes", "section", "nav", "aside", "hgroup", "header", "footer", "p", "h1", "h2", "h3", "h4", "h5", "h6",
//    "ul", "ol", "pre", "div", "blockquote", "hr", "address", "figure", "figcaption", "form", "fieldset", "ins",
//    "del", "s", "dl", "dt", "dd", "li", "table", "caption", "thead", "tfoot", "tbody", "colgroup", "col", "tr", "th",
//    "td", "video", "audio", "canvas", "details", "menu", "plaintext", "template", "article", "main",
//    "svg", "math"
//]

//class Node {
//    let tag: String
//    let attribute: String?
//
//    weak var parentsNode: Node?
//    let childNode: [Node]
//
//    private static let emptyNode = [Node]()
//
//    init(tag: String, attribute: String) {
//        self.tag = tag
//        self.attribute = attribute
//        self.childNode = Node.emptyNode
//    }
//}


//    mutating func tree(html: String)  {
//        var searchPoint = html.startIndex
//
//        let searchRange = html[searchPoint..<html.endIndex]
//        guard let tagWordStart = searchRange.range(of: "<"),
//              let tagWordEnd = searchRange.range(of: " ") else {
//            return
//        }
//
//        let startIndex = html[tagWordStart].endIndex
//        let endIndex = html[tagWordEnd].startIndex
//
//        let tag = html[startIndex..<endIndex]
//        print(tag)
//
//        if tag.first == "/" {
//            var endTag = tag
//            endTag.remove(at: tag.startIndex)
//            endTag.remove(at: tag.endIndex)
//
//
//        }
//
//        let attStart = html[tagWordEnd].endIndex
//        guard let attEnd = html[attStart..<html.endIndex].range(of: "\">") else {
//            return
//        }
//
//        let att = html[attStart..<html[attEnd].startIndex]
//        print(att)
//
//        let contentRange = html[html[attEnd].endIndex..<html.endIndex]
//        let content = html[contentRange.firstIndex(of: "<")!..<html.endIndex]
//
//        nodes.append(Node(tag: String(tag), attribute: String(att)))
//        tree(html: String(content))
//
//
//        let contentStart = html[attEnd].endIndex
//        guard let contentEnd = html[contentStart..<html.endIndex].range(of: "<\(tag)>") else {
//            return
//        }
//
//        let contentdd = html[contentStart..<html[contentEnd].startIndex]
//    }
//


//    func parse(className: String, blockType: String, lnlineType: String) -> String? {
//        let classBlock = try? searchClassBlock(className: className, blockType: blockType)
//
//    }
