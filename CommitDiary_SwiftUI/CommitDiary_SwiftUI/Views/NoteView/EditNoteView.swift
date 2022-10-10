//
//  NoteDetailView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct EditNoteView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var note: Note
    @State var isModifyMode: Bool
    
    var body: some View {
        NavigationView {
            content
        }
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            dateView()
            commitCountView()
            titleView()
            noteContentView()
            exitButtonView()
            Spacer()
        }
    }
}

extension EditNoteView {
    private func dateView() -> some View {
        Text(note.date.longDateString())
                    .font(.system(size: 24))
                    .foregroundColor(.black)
    }
    
    private func commitCountView() -> some View {
        Text("오늘의 커밋은 \(note.commitCount)회!")
    }
    
    private func titleView() -> some View {
        TextField(note.title, text: $note.title)
            .placeholder(when: note.title.isEmpty) {
                Text("제목을 입력하세요")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
            }
            .font(.system(size: 24))
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
    }
    
    private func noteContentView() -> some View {
        TextField(note.description, text: $note.description)
            .placeholder(when: note.description.isEmpty) {
                Text("내용을 입력하세요")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
            }
            .font(.system(size: 24))
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
    }
    
    private func exitButtonView() -> some View {
        HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("취소")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(width: 130, height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(20)
            }
            
            Button {
                note.store(in: managedObjectContext)
                saveContext()
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("저장")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(width: 130, height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(20)
            }
        }
    }
    
    private func saveContext() {
        do {
          try managedObjectContext.save()
        } catch {
          print("Error saving managed object context: \(error)")
        }
    }
}

//struct EditNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditNoteView(note: Note(commitCount: 8))
//    }
//}
