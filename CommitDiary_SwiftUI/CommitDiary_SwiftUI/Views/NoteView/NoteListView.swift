//
//  NoteListView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI
import CoreData

struct NoteListView: View {
    @EnvironmentObject var contributionService: ContributionService
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
      entity: NoteEntity.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \NoteEntity.date, ascending: false)
      ]
    ) var notes: FetchedResults<NoteEntity>
    @Binding var colorTheme: Theme
    
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
            .navigationTitle("텅 💬")
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
            let newNote = Note(commitCount: contributionService.todaysCommit)
            EditNoteView(note: newNote, isModifyMode: false, colorTheme: $colorTheme)
        } label: {
            Image(systemName: "plus")
        }
    }
    
    private func listView() -> some View {
        List {
            ForEach(notes, id: \.id) {noteObject in
                makeNavigationLink(of: Note(managedObject: noteObject))
                    .listRowBackground(colorTheme.viewBackground)
            }
            .onDelete(perform: deleteNote)
            .listRowSeparator(.visible)
        }
    }
    
    private func makeNavigationLink(of note: Note) -> some View {
        NavigationLink {
            EditNoteView(note: note, isModifyMode: true, colorTheme: $colorTheme)
        } label: {
            NoteRowView(
                title: note.title,
                date: note.date,
                commitCount: note.commitCount
            )
        }
    }
}

extension NoteListView {
    func deleteNote(at offsets: IndexSet) {
        for offset in offsets {
            let note = notes[offset]
            managedObjectContext.delete(note)
        }
        saveContext()
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
        let contributionService = ContributionService()
        NoteListView(colorTheme: .constant(Theme.blue))
            .environmentObject(contributionService)
    }
}
