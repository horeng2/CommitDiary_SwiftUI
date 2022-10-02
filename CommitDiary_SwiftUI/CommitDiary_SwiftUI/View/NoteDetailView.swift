//
//  NoteDetailView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct NoteDetailView: View {
    @State var note: String
    var body: some View {
        NavigationView {
            content
                .navigationTitle(note)
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            dateView()
            commitCountView()
            noteContentView()
            Spacer()
        }
    }
}

extension NoteDetailView {
    private func dateView() -> some View {
        Text("2022.09.30.")
    }
    
    private func titleView() -> some View {
        Text(note)
    }
    
    private func commitCountView() -> some View {
        Text("3번 커밋했어요")
    }
    
    private func noteContentView() -> some View {
        Text("""
sdfsdfsdfsfsfsfsdfsfdssfsdfsfsfsfsfs
sdfsdfsdfsfsfsfsdfsfdssfsdfsfsfsfsf
sdfsdfsdfsfsfsfsdfsfdssfsdfsfsfsfsf
""")
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(note: "note")
    }
}
