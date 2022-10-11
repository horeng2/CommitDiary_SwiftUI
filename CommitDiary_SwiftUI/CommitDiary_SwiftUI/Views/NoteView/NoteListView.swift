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
    var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    @State var refreshID = UUID()
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
      entity: NoteEntity.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \NoteEntity.id, ascending: true)
      ]
    ) var notes: FetchedResults<NoteEntity>

    
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
            EditNoteView(note: Note(commitCount: contributionService.todaysCommit),
                         isModifyMode: false)
        } label: {
            Image(systemName: "plus")
        }
    }
    
    private func listView() -> some View {
        List {
            ForEach(notes, id: \.id) {noteObject in
                makeNavigationLink(of: Note(managedObject: noteObject))
            }
            .onDelete{ indexSet in
                let index = indexSet[indexSet.startIndex]
                managedObjectContext.delete(notes[index])
            }
            .listRowSeparator(.visible)
        }
    }
    
    private func makeNavigationLink(of note: Note) -> some View {
        NavigationLink {
            EditNoteView(note: note, isModifyMode: true)
        } label: {
            NoteRowView(title: note.title, date: note.date, commitCount: note.commitCount)
        }
        .id(refreshID)
        .onReceive(self.didSave) { _ in
            self.refreshID = UUID()
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
        NoteListView()
            .environmentObject(contributionService)
    }
}
