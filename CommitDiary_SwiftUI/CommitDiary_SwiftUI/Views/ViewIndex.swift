//
//  ViewIndex.swift
//  Just3Days
//
//  Created by 서녕 on 2022/07/21.
//

import Foundation

enum ViewIndex {
    case commitStatusView
    case noteListView
    case settingView
    
    var index: Int {
        switch self {
        case .commitStatusView:
            return 0
        case .noteListView:
            return 1
        case .settingView:
            return 2
        }
    }
}
