//
//  Model+CoreData.swift
//  CommitDiary_SwiftUI
//
//  Created by 서녕 on 2022/10/04.
//

import Foundation
import CoreData

extension NoteEntity: ManagedEntity { }

extension Note {
    init(managedObject: NoteEntity) {
        self.id = managedObject.id
        self.title = managedObject.title
        self.date = managedObject.date
        self.description = managedObject.noteDescription
    }
    
    func store(in context: NSManagedObjectContext) {
        guard let note = NoteEntity.insertNew(in: context) else {
            return
        }
        note.id = id
        note.title = title
        note.date = date
        note.noteDescription = description
    }
    
    func update(of object: NSManagedObject) {
        object.setValue(title, forKey: NoteEntity.titleKey)
        object.setValue(date, forKey: NoteEntity.dateKey)
        object.setValue(description, forKey: NoteEntity.noteDescriptionKey)
    }
}
