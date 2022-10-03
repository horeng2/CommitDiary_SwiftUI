//
//  NoteListView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct NoteListView: View {
    @State var isShowNoteDetailView = false
    let notes = ["aaa", "bbb", "vvv"]
    
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
        Button {
            isShowNoteDetailView = true
        } label: {
            Image(systemName: "plus")
                .fullScreenCover(isPresented: $isShowNoteDetailView) {
                    NoteDetailView(note: "")
                }
        }
    }
    
    private func listView() -> some View {
        List {
            ForEach(notes, id: \.self) {note in
                makeNavigationLink(of: note)
            }
            .listRowSeparator(.visible)
        }
    }
    
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
