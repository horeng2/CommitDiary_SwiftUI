//
//  NoteRowView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct NoteRowView: View {
    @ObservedObject var noteEntity: NoteEntity
    
    var body: some View {
        content
    }
    
    private var content: some View {
        HStack {
            noteInfoView()
            Spacer()
            commitCountView()
        }
        .padding(.vertical, 10)
    }
}

extension NoteRowView {
    private func noteInfoView() -> some View {
        VStack(alignment: .leading) {
            Text(noteEntity.title)
                .font(.system(.headline, design: .monospaced))
            Text(noteEntity.date.toString())
                .font(.system(.subheadline, design: .monospaced))
        }
    }
    
    private func commitCountView() -> some View {
        Text("🌱\(noteEntity.commitCount)")
            .font(.system(.body, design: .monospaced))
    }
}
