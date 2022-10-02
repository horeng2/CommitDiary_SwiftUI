//
//  CommitNoteListView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct CommitNoteListView: View {
    let notes = ["aaa", "bbb", "vvv"]
    var body: some View {
        NavigationView {
            content
                .navigationTitle("잔디일기")
        }
    }
    
    private var content: some View {
        commitNoteListView()
    }
}

extension CommitNoteListView {
    private func commitNoteListView() -> some View {
        List {
            ForEach(notes, id: \.self) {note in
                makeNavigationLink(of: note)
            }
            .listRowSeparator(.visible)
        }
    }
    
    private func makeNavigationLink(of note: String) -> some View {
        NavigationLink {
            //detail view
        } label: {
            CommitNoteRowView(title: note, commitCount: 5)
        }
    }
}

struct CommitNoteListView_Previews: PreviewProvider {
    static var previews: some View {
        CommitNoteListView()
    }
}
