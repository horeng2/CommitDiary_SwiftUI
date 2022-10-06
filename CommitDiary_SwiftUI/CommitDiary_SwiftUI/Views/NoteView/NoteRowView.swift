//
//  NoteRowView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct NoteRowView: View {
    @State var title: String
    @State var commitCount: Int
    
    var body: some View {
        content
    }
    
    private var content: some View {
        HStack {
            noteInfoView()
            Spacer()
            commitCountView()
        }
    }
}

extension NoteRowView {
    private func noteInfoView() -> some View {
        VStack {
            Text("date")
            Text(title)
        }
    }
    
    private func commitCountView() -> some View {
        Text("🌱\(commitCount)")
    }
}

struct NoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoteRowView(title: "title", commitCount: 5)
    }
}