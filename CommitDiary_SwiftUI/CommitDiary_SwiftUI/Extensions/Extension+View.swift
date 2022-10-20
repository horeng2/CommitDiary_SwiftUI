//
//  Extension+View.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/20.
//

import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(
        when willShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
            ZStack(alignment: alignment) {
                if willShow {
                    placeholder()
                }
                self
            }
        }
    
    func logContent<Content: View>(
        @ViewBuilder logText: () -> Content
    ) -> some View {
        VStack(spacing: 10) {
            self
                .font(.system(.title2, design: .monospaced))
                .foregroundColor(.gray)
            logText()
                .font(.system(.title2, design: .monospaced))
        }
    }
}
