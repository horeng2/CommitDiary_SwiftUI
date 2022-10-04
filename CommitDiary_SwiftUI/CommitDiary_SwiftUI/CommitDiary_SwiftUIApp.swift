//
//  CommitDiary_SwiftUIApp.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/03.
//

import SwiftUI

@main
struct CommitDiary_SwiftUIApp: App {
    @StateObject var userInfoService = UserInfoService()
    let coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(userInfoService)
                .environment(\.managedObjectContext, coreDataStack.context)
                .task {
                    await userInfoService.loadUserInfo()
                }
        }
    }
}
