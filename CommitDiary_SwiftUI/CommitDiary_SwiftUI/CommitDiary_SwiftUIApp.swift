//
//  CommitDiary_SwiftUIApp.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

@main
struct CommitDiary_SwiftUIApp: App {
    let coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(\.managedObjectContext, coreDataStack.context)
        }
    }
}
