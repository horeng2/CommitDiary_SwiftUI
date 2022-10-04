//
//  NoteEntity+CoreDataProperties.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//
//

import Foundation
import CoreData


extension NoteEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var noteDescription: String
    
    static let idKey = "id"
    static let titleKey = "title"
    static let dateKey = "date"
    static let noteDescriptionKey = "noteDescription"
}