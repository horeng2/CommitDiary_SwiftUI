//
//  NoteDetailView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct NoteDetailView: View {
    @State var note: String
    var body: some View {
        NavigationView {
            content
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            dateView()
            commitCountView()
            noteContentView()
            Spacer()
        }
    }
}

extension NoteDetailView {
    private func dateView() -> some View {
        TextField(note, text: $note)
            .placeholder(when: note.isEmpty) {
                Text("제목")
            }
    }
    
    private func titleView() -> some View {
        TextField(note, text: $note)
    }
    
    private func commitCountView() -> some View {
        TextField("3번 커밋했어요", text: $note)
    }
    
    private func noteContentView() -> some View {
        Text("""
sdfsdfsdfsfsfsfsdfsfdssfsdfsfsfsfsfs
sdfsdfsdfsfsfsfsdfsfdssfsdfsfsfsfsf
sdfsdfsdfsfsfsfsdfsfdssfsdfsfsfsfsf
""")
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(note: "note")
    }
}
