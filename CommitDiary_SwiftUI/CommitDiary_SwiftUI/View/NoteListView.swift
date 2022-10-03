//
//  NoteListView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct NoteListView: View {
    @State var isShowNoteDetailView = false
    let notes = [Note(title: "1", date: Date(), description: "111"),
                 Note(title: "2", date: Date(), description: "222"),
                 Note(title: "3", date: Date(), description: "333")]
    
    var body: some View {
        NavigationView {
            content
        }
    }
    
    private var content: some View {
        listView()
            .navigationTitle("잔디일기")
            .toolbar {
                plusButtonView()
            }
    }
}

extension NoteListView {
    private func plusButtonView() -> some View {
        NavigationLink {
            NoteDetailView(note: Note(), commitCount: 7)
        } label: {
            Image(systemName: "plus")
        }
    }
    
    private func listView() -> some View {
        List {
            ForEach(notes, id: \.title) {note in
                makeNavigationLink(of: note)
            }
            .listRowSeparator(.visible)
        }
    }
    
    private func makeNavigationLink(of note: Note) -> some View {
        NavigationLink {
            NoteDetailView(note: note, commitCount: 7)
        } label: {
            NoteRowView(title: note.title, commitCount: 5)
        }
    }
}

struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView()
    }
}
