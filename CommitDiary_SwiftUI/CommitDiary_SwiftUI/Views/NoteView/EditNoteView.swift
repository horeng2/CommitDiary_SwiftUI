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
    @Environment(\.presentationMode) private var presentationMode
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
    }
    
    private var content: some View {
        ScrollViewReader { (proxy: ScrollViewProxy) in
            ScrollView(.vertical) {
                dayInfoView()
                pickLogView()
                titleView()
                noteDescriptionView()
                    .onChange(of: note.noteDescription) { newValue in
                        withAnimation {
                            proxy.scrollTo("newInput", anchor: .bottom)
                        }
                    }.id("newInput")
            }
        }
    }
}

// MARK: - Views
extension EditNoteView {
    
    // MARK: - Date, CommitCount Text
    private func dayInfoView() -> some View {
        VStack {
            dateView()
            commitCountView()
        }
        .padding(.top, 0)
    }
    
    private func dateView() -> some View {
        Text(note.date.toString())
            .font(.system(.title2, design: .monospaced))
            .fontWeight(.bold)
            .foregroundColor(.black)
    }
    
    private func commitCountView() -> some View {
        Text("🌱 × \(note.commitCount)")
            .font(.system(.title3, design: .monospaced))
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .padding(.top, 5)
    }
    
    // MARK: - Repository, Commit Picker
    private func pickLogView() -> some View {
        VStack {
            pickRepoView()
            pickCommitView()
        }
        .padding()
    }
    
    private func pickRepoView() -> some View {
        HStack {
            Text("레포지토리")
                .modifier(SubtitleTextModifier())
            Spacer()
            Menu {
                Picker("레포지토리", selection: $note.repositoryName) {
                    let repoList = commitInfoService.repos.filter{ $0.repoName != note.repositoryName }
                    ForEach(repoList, id: \.id) { repo in
                        Text(repo.repoName).tag(repo.repoName)
                    }
                }
            } label: {
                Text(note.repositoryName)
                    .frame(alignment: .trailing)
            }
            .onAppear {
                Task {
                    await commitInfoService.loadCommits(of: note.repositoryName)
                }
            }
            .onChange(of: note.repositoryName, perform: { repoName in
                note.commitMessage = "선택해주세요.".localizedString()
                Task {
                    await commitInfoService.loadCommits(of: repoName)
                }
            })
        }
    }
    
    private func pickCommitView() -> some View {
        HStack {
            Text("커밋 내역")
                .modifier(SubtitleTextModifier())
            Spacer()
            Menu {
                Picker("커밋", selection: $note.commitMessage) {
                    let commitList = commitInfoService.commitMessages
                        .filter{ $0.infoItmes.message != note.commitMessage }
                    ForEach(commitList, id: \.id) { commit in
                        Text(commit.infoItmes.message).tag(commit.infoItmes.message)
                    }
                }
            } label: {
                Text(note.commitMessage)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    
    // MARK: - Edit Title, Description Text
    private func titleView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("제목")
                .modifier(SubtitleTextModifier())
            TextField(note.title, text: $note.title)
                .placeholder(when: note.title.isEmpty) {
                    Text("제목을 입력해주세요.")
                        .foregroundColor(colorTheme.levelOneColor)
                }
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.black)
                .padding(.leading, 3)
                .onReceive(Just(note.title)) { _ in
                    if note.title.count > 20 {
                        note.title = String(note.title.prefix(20))
                    }
                }
        }
        .padding()
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }
    
    private func noteDescriptionView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("내용")
                .modifier(SubtitleTextModifier())
            TextEditor(text: $note.noteDescription)
                .placeholder(when: note.noteDescription.isEmpty) {
                    Text("내용을 입력해주세요.")
                        .foregroundColor(colorTheme.levelOneColor)
                        .padding(.leading, 3)
                }
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.black)
                .onAppear{
                    UITextView.appearance().backgroundColor = .clear
                }
        }
        .padding()
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }
    
    private func saveButtonView() -> some View {
        Button {
            if note.title.isEmpty || note.noteDescription.isEmpty {
                isEmptyData = true
            } else {
                saveNote(isModifyMode: isModifyMode)
            }
        } label: {
            Text("저장")
                .font(.system(.body))
                .fontWeight(.bold)
        }
        .alert("모든 값을 입력해주세요.", isPresented: $isEmptyData) {}
    }
}

// MARK: - Core Data
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
