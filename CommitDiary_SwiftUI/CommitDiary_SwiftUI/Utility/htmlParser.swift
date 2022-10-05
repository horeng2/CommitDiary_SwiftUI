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
        let dateKey = "data-date="
        let commitCountKey = "data-count="
        let levelKey = "data-level"
        
        return html.map { inline -> Contribution in
            let infos = inline.components(separatedBy: " ")
            let date = infos.filter{ $0.contains(dateKey) }.first ?? ""
            let commitCount = infos.filter{ $0.contains(commitCountKey) }.first ?? ""
            let level = infos.filter{ $0.contains(levelKey) }.first ?? ""
                
            let contribution = Contribution(date: date.stringToDate(),
                                            commitCount: Int(commitCount) ?? 0,
                                            level: CommitLevel(rawValue: Int(level) ?? 0) ?? .zero)
            return contribution
        }
    }
    
    func searchClassBlock(html: String, className: String, blockType: String) throws -> String {
        var block = ""
        var searchPoint = html.startIndex
        
        while searchPoint < html.endIndex {
            let searchRange = html[searchPoint..<html.endIndex]
            guard let blockStart = searchRange.range(of: className),
                  let blockEnd = searchRange.range(of: "></\(blockType)>") else {
                throw HTMLError.classInputError
            }
            let startIndex = html[blockStart].startIndex
            let endIndex = html[blockEnd].startIndex
            
            let searchedBlock = html[startIndex..<endIndex]
            searchPoint = html[blockEnd].endIndex
            
            block = String(searchedBlock)
        }
        return block
    }
    
    func searchInline(html: String, inlineType: String) throws -> [Contribution] {
        var inlines = [String]()
        var searchPoint = html.startIndex
        
        while searchPoint < html.endIndex {
            let searchRange = html[searchPoint..<html.endIndex]
            guard let inlineStart = searchRange.range(of: "\(inlineType) "),
                  let inlineEnd = searchRange.range(of: "></\(inlineType)>") else {
                throw HTMLError.inlineInputError
            }
            let startIndex = html[inlineStart].endIndex
            let endIndex = html[inlineEnd].startIndex
    
            let inline = html[startIndex..<endIndex]
            searchPoint = html[inlineEnd].endIndex
            
            inlines.append(String(inline))
        }
        
        return parseInline(html: inlines, inlineType: inlineType)
    }

    let blockTags: [String] = [
        "html", "head", "body", "frameset", "script", "noscript", "style", "meta", "link", "title", "frame",
        "noframes", "section", "nav", "aside", "hgroup", "header", "footer", "p", "h1", "h2", "h3", "h4", "h5", "h6",
        "ul", "ol", "pre", "div", "blockquote", "hr", "address", "figure", "figcaption", "form", "fieldset", "ins",
        "del", "s", "dl", "dt", "dd", "li", "table", "caption", "thead", "tfoot", "tbody", "colgroup", "col", "tr", "th",
        "td", "video", "audio", "canvas", "details", "menu", "plaintext", "template", "article", "main",
        "svg", "math"
    ]
}

enum HTMLError: Error {
    case classInputError
    case inlineInputError
    case encodingError
}

//기능 구현 뒤 시도해볼 코드

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
