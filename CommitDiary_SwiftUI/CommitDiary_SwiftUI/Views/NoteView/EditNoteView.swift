//
//  NoteDetailView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI
import Combine

struct EditNoteView: View {
    @EnvironmentObject var commitInfoService: CommitInfoService
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var note: Note
    @State var isModifyMode: Bool
    @State var isEmptyData = false
    @State var selectedRepoId = UUID()
    @State var selectedCommitId = UUID()
    @Binding var colorTheme: Theme
    
    
    var body: some View {
        content
            .toolbar {
                saveButtonView()
            }
    }
    
    private var content: some View {
        VStack(alignment: .center) {
            dateView()
            commitCountView()
            noteEditView()
        }
        .background(colorTheme.viewBackground)
    }
}

// MARK: Views
extension EditNoteView {
    private func dateView() -> some View {
        Text(note.date.toString())
            .font(.system(size: 23))
            .foregroundColor(.black)
            .padding(.top)
    }
    
    private func commitCountView() -> some View {
        Text("🌱 오늘의 커밋은 \(note.commitCount)회 🌱")
            .font(.system(size: 20))
            .fontWeight(.medium)
            .foregroundColor(.gray)
            .padding(.bottom)
    }
    
    private func noteEditView() -> some View {
        List {
            pickLogView()
            titleView()
            noteContentView()
        }
    }
    
    private func pickLogView() -> some View {
        Section {
            Picker("레파지토리", selection: $selectedRepoId) {
                Text("선택안함").tag(UUID())
                ForEach(commitInfoService.repos, id: \.id) { repo in
                    Text(repo.repoName)
                        .tag(repo.id)
                }
            }
            .onChange(of: selectedRepoId, perform: { id in
                Task {
                    await commitInfoService.loadCommits(of: id)
                }
            })
            Picker(selection: $selectedCommitId, label: Text("커밋")) {
                Text("선택안함").tag(UUID())
                ForEach(commitInfoService.commitComments, id: \.id) { commit in
                    Text(commit.infoItmes.message)
                        .tag(commit.id)
                }
            }
        } header: {
            Text("선택해주세요.")
        }
    }
    
    private func titleView() -> some View {
        Section {
            TextField("제목을 입력해주세요.", text: $note.title)
        } header: {
            Text("제목")
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }
    
    private func noteContentView() -> some View {
        Section {
            ZStack(alignment: .leading) {
                if note.description.isEmpty {
                    noteContentPlacehoder()
                }
                VStack {
                    TextEditor(text: $note.description)
                        .frame(minHeight: 150, maxHeight: 300)
                        .opacity(note.description.isEmpty ? 0.85 : 1)
                    Spacer()
                }
            }
        } header: {
            Text("내용")
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }
    
    private func noteContentPlacehoder() -> some View {
        VStack {
            Text("내용을 입력해주세요.")
                .padding(.top, 10)
                .padding(.leading, 5)
                .opacity(0.2)
            Spacer()
        }
    }
    
    private func saveButtonView() -> some View {
        Button {
            if note.title.isEmpty || note.description.isEmpty {
                isEmptyData = true
            } else {
                saveNote(isModifyMode: isModifyMode)
            }
        } label: {
            Text("저장")
                .font(.system(size: 20))
        }
        .alert("모든 값을 입력해주세요.", isPresented: $isEmptyData) {}
    }
}

// MARK: Core Data
extension EditNoteView {
    private func saveNote(isModifyMode: Bool) {
        if isModifyMode {
            note.update(note, in: managedObjectContext)
        } else {
            note.store(in: managedObjectContext)
        }
        saveContext()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

struct EditNoteView_Previews: PreviewProvider {
    static var previews: some View {
        EditNoteView(note: Note(commitCount: 8), isModifyMode: true, colorTheme: .constant(Theme.blue))
    }
}
