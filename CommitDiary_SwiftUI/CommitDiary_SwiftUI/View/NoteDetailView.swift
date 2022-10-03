//
//  NoteDetailView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct NoteDetailView: View {
    @State var note: Note
    let commitCount: Int
    
    var body: some View {
        NavigationView {
            content
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            dateView()
            commitCountView()
            titleView()
            noteContentView()
            Spacer()
        }
    }
}

extension NoteDetailView {
    private func dateView() -> some View {
        Text(note.date.longDateString())
                    .font(.system(size: 24))
                    .foregroundColor(.black)
    }
    
    private func commitCountView() -> some View {
        Text("오늘의 커밋은 \(commitCount)회!")
    }
    
    private func titleView() -> some View {
        TextField(note.title, text: $note.title)
            .placeholder(when: note.title.isEmpty) {
                Text("제목을 입력하세요")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
            }
            .font(.system(size: 24))
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
    }
    
    private func noteContentView() -> some View {
        TextField(note.description, text: $note.description)
            .placeholder(when: note.description.isEmpty) {
                Text("내용을 입력하세요")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
            }
            .font(.system(size: 24))
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(note: Note(title: "", date: Date(), description: ""), commitCount: 8)
    }
}
