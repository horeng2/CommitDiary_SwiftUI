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
    @State var note: Note
    @State var isModifyMode: Bool
    @State var isEmptyData = false
    
    var body: some View {
            content
            .toolbar {
                saveButtonView()
            }
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            dateView()
            commitCountView()
            titleView()
            noteContentView()
            Spacer()
        }
    }
}

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
                .fontWeight(.bold)
        }
        .alert("모든 값을 입력해주세요.", isPresented: $isEmptyData) {}
    }
    
    private func dateView() -> some View {
        Text(note.date.toString())
                    .font(.system(size: 25))
                    .foregroundColor(.black)
    }
    
    private func commitCountView() -> some View {
        Text("🌱 오늘의 커밋은 \(note.commitCount)회 🌱")
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.gray)
            .padding()
    }
    
    private func titleView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("제목")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom, 0)
            TextField(note.title, text: $note.title)
                .font(.system(size: 22))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onReceive(Just(note.title)) { _ in
                    if note.title.count > 20 {
                        note.title = String(note.title.prefix(20))
                    }
                }
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }
    
    private func noteContentView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("내용")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom, 0)
            TextEditor(text: $note.description)
                .font(.system(size: 22))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black1, lineWidth: 1)
                )
                .padding()
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
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
        EditNoteView(note: Note(commitCount: 8), isModifyMode: true)
    }
}
