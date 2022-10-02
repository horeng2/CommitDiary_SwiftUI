//
//  NoteListView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct NoteListView: View {
    let notes = ["aaa", "bbb", "vvv"]
    var body: some View {
        NavigationView {
            content
                .navigationTitle("잔디일기")
        }
    }
    
    private var content: some View {
        List {
            ForEach(notes, id: \.self) {note in
                makeNavigationLink(of: note)
            }
            .listRowSeparator(.visible)
        }
    }
}

extension NoteListView {
    private func makeNavigationLink(of note: String) -> some View {
        NavigationLink {
            NoteDetailView(note: note)
        } label: {
            NoteRowView(title: note, commitCount: 5)
        }
    }
}

struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView()
    }
}
