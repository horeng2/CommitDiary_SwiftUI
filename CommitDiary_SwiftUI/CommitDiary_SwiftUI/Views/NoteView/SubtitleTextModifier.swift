//
//  SubtitleTextModifier.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/20.
//

import Foundation
import SwiftUI

struct SubtitleTextModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.headline, design: .monospaced))
            .foregroundColor(.gray)
    }
}
