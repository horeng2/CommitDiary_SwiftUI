//
//  ContentView.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

struct RootTabView: View {
    @State var index = ViewIndex.commitStatusView.index
    
    var body: some View {
        TabView(selection: $index) {
            CommitStatusView()
                .tabItem {
                    Image(systemName: "flame")
                    Text("Today")
                }
            CommitNoteListView()
                .tabItem {
                    Image(systemName: "crown")
                    Text("Note")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
