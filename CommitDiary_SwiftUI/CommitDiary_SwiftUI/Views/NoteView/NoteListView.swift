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
            EditNoteView(note: Note(commitCount: contributionService.todaysCommit), isModifyMode: false, colorTheme: $colorTheme)
        } label: {
            Image(systemName: "plus")
        }
    }
    
    private func listView() -> some View {
        List {
            ForEach(notes, id: \.objectID) { noteObject in
                NavigationLink {
                    EditNoteView(note: Note(managedObject: noteObject), isModifyMode: true, colorTheme: $colorTheme)
                } label: {
                    NoteRowView(noteEntity: noteObject)
                }
                .listRowBackground(colorTheme.viewBackground)
            }
            .onDelete(perform: deleteNote)
            .listRowSeparator(.visible)

        }
    }
}

extension NoteListView {
    func deleteNote(at offsets: IndexSet) {
        withAnimation {

        managedObjectContext.perform {
            offsets.map { notes[$0] }.forEach(managedObjectContext.delete)
            saveContext()
        }
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
        let contributionService = ContributionService()
        NoteListView(colorTheme: .constant(Theme.blue))
            .environmentObject(contributionService)
    }
}
