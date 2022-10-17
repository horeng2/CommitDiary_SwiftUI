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
        .padding(.top)
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
            formTitleView(title: "레포지토리 선택")
            Spacer()
            Picker("레포지토리", selection: $note.repositoryName) {
                let repoList = commitInfoService.repos.filter{ $0.repoName != note.repositoryName }
                Text(note.repositoryName).tag(note.repositoryName)
                ForEach(repoList, id: \.id) { repo in
                    Text(repo.repoName).tag(repo.repoName)
                }
            }
            .onChange(of: note.repositoryName, perform: { repoName in
                Task {
                    await commitInfoService.loadCommits(of: repoName)
                }
            })
        }
    }
    
    private func pickCommitView() -> some View {
        HStack {
            formTitleView(title: "커밋 내역 선택")
            Spacer()
            Picker("커밋", selection: $note.commitMessages) {
                let commitList = commitInfoService.commitMessages
                    .filter{ $0.infoItmes.message != note.commitMessages }
                Text(note.commitMessages).tag(note.commitMessages)
                ForEach(commitList, id: \.id) { commit in
                    Text(commit.infoItmes.message).tag(commit.infoItmes.message)
                }
            }
        }
    }

    
    // MARK: Edit Title, Description Text
    
    private func titleView() -> some View {
        VStack(alignment: .leading) {
            formTitleView(title: "제목")
            TextField(note.title, text: $note.title)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.black)
                .border(colorTheme.levelOneColor)
                .textFieldStyle(.roundedBorder)
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
        VStack(alignment: .leading) {
            formTitleView(title: "내용")
            TextEditor(text: $note.description)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.black)
                .frame(minHeight: 500)
                .overlay(
                    Rectangle()
                        .stroke(colorTheme.levelOneColor)
                )
        }
        .padding()
        .onAppear(perform: UIApplication.shared.hideKeyboard)
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
                .font(.system(.body))
                .fontWeight(.bold)
        }
        .alert("모든 값을 입력해주세요.", isPresented: $isEmptyData) {}
    }
    
    
    //MARK: View Utility
    
    private func formTitleView(title: String) -> some View {
        Text(title)
            .font(.system(.headline, design: .monospaced))
            .foregroundColor(.gray)
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
