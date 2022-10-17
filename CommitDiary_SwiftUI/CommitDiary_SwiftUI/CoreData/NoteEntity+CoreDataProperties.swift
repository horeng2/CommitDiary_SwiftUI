//
//  NoteEntity+CoreDataProperties.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/17.
//
//

import Foundation
import CoreData


extension NoteEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var noteDescription: String
    @NSManaged public var commitCount: Int
    @NSManaged public var repositoryName: String
    @NSManaged public var commitMessage: String

    
    static let idKey = "id"
    static let titleKey = "title"
    static let dateKey = "date"
    static let noteDescriptionKey = "noteDescription"
    static let commitCountKey = "commitCount"
    static let repositoryName = "repositoryName"
    static let commitMessage = "commitMessage"
}
