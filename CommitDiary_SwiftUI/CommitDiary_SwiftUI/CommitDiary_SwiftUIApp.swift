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
    @StateObject var contributionService = ContributionService()
    let coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            RootTabView(contributionService: contributionService, userInfoService: userInfoService)
                .environment(\.managedObjectContext, coreDataStack.context)
                .task {
                    await userInfoService.loadUserInfo()
                }
        }
    }
}
