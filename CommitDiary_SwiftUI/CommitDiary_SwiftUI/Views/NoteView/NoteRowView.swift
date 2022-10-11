//
//  NoteRowView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct NoteRowView: View {
    @State var title: String
    @State var date: Date
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
        .padding(.vertical, 10)
    }
}

extension NoteRowView {
    private func noteInfoView() -> some View {
        VStack(alignment: .leading) {
            Text(date.toString())
            Text(title)
                .fontWeight(.bold)
        }
    }
    
    private func commitCountView() -> some View {
        Text("🌱\(commitCount)")
    }
}

struct NoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoteRowView(title: "title", date: Date(), commitCount: 5)
    }
}
