//
//  NoteDetailView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI
import Combine

struct EditNoteView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var commitInfoService: CommitInfoService
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
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var content: some View {
        ScrollViewReader { (proxy: ScrollViewProxy) in
            ScrollView {
                dayInfoView()
                pickLogView()
                titleView()
                noteDescriptionView()
                    .onChange(of: note.description) { newValue in
                        proxy.scrollTo("newInput", anchor: .bottom)
                    }.id("newInput")
            }
        }
    }
}

// MARK: Views

extension EditNoteView {
    
    // MARK: Date, CommitCount Text

    private func dayInfoView() -> some View {
        VStack {
            dateView()
            commitCountView()
        }
        .padding()
    }
    
    private func dateView() -> some View {
        Text(note.date.toString())
            .font(.system(size: 23, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
    }
    
    private func commitCountView() -> some View {
        Text("🌱오늘의 커밋은 \(note.commitCount)회🌱")
            .font(.system(size: 20, weight: .medium, design: .monospaced))
            .foregroundColor(.gray)
            .padding(.top, 5)
    }
    
    
    // MARK: Repository, Commit Picker
    
    private func pickLogView() -> some View {
        VStack {
            pickRepoView()
            pickCommitView()
        }
        .padding()
    }
    
    private func pickRepoView() -> some View {
        HStack {
            Text("레포지토리 선택")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
            Spacer()
            Picker("레포지토리", selection: $selectedRepoId) {
                Text("선택해주세요.").tag(UUID())
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
        }
    }
    
    private func pickCommitView() -> some View {
        HStack {
            Text("커밋 내역 선택")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
            Spacer()
            Picker("커밋", selection: $selectedCommitId) {
                Text("선택해주세요.").tag(UUID())
                ForEach(commitInfoService.commitComments, id: \.id) { commit in
                    Text(commit.infoItmes.message)
                        .tag(commit.id)
                }
            }
        }
    }

    
    // MARK: Edit Title, Description Text
    
    private func titleView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("제목")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal)
            TextField(note.title, text: $note.title)
                .font(.system(size: 18))
                .foregroundColor(.black)
                .border(colorTheme.levelOneColor)
                .textFieldStyle(.roundedBorder)
                .onReceive(Just(note.title)) { _ in
                    if note.title.count > 20 {
                        note.title = String(note.title.prefix(20))
                    }
                }
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }
    
    private func noteDescriptionView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("내용")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal)
            TextEditor(text: $note.description)
                .frame(minHeight: 500)
                .font(.system(size: 18))
                .foregroundColor(.black)
                .overlay(
                    Rectangle()
                        .stroke(colorTheme.levelOneColor)
                )
                .padding()
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }
    
    private func noteDescriptionPlacehoder() -> some View {
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
