//
//  NoteListView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI
import CoreData

struct NoteListView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
      entity: NoteEntity.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \NoteEntity.id, ascending: true)
      ]
    ) var notes: FetchedResults<NoteEntity>
    
    @State var isShowNoteDetailView = false
    
    var body: some View {
        NavigationView {
            if notes.isEmpty {
                emptyContent
            } else {
                listContent
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private var emptyContent: some View {
        Text("기록을 작성해주세요.")
            .foregroundColor(.gray)
            .navigationTitle("빈 일기장 💬")
            .toolbar {
                plusButtonView()
            }
    }
    
    private var listContent: some View {
        listView()
            .navigationTitle("잔디일기 🌱")
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
            ForEach(notes, id: \.id) {noteObject in
                makeNavigationLink(of: Note(managedObject: noteObject))
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
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}

struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView()
    }
}
