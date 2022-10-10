//
//  Theme.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/10.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable {
    case defaultGreen = "초록"
    case blue = "파랑"
    case orange = "주황"
    case pink = "분홍"
    case black = "검정"
    
    func colorSet(by level: CommitLevel) -> Color {
        switch level {
        case .zero:
            return .level0
        case .one:
            return levelOneColor
        case .two:
            return levelTwoColor
        case .three:
            return levelThreeColor
        case .four:
            return levelfourColor
        }
    }
        
    var levelOneColor: Color {
        switch self {
        case .defaultGreen:
            return .defaultGreen1
        case .blue:
            return .blue1
        case .orange:
            return .orange1
        case .pink:
            return .pink1
        case .black:
            return .black1
        }
    }
    
    var levelTwoColor: Color {
        switch self {
        case .defaultGreen:
            return .defaultGreen2
        case .blue:
            return .blue2
        case .orange:
            return .orange2
        case .pink:
            return .pink2
        case .black:
            return .black2
        }
    }
    
    var levelThreeColor: Color {
        switch self {
        case .defaultGreen:
            return .defaultGreen3
        case .blue:
            return .blue3
        case .orange:
            return .orange3
        case .pink:
            return .pink3
        case .black:
            return .black3
        }
    }
    
    var levelfourColor: Color {
        switch self {
        case .defaultGreen:
            return .defaultGreen4
        case .blue:
            return .blue4
        case .orange:
            return .orange4
        case .pink:
            return .pink4
        case .black:
            return .black4
        }
    }
}

