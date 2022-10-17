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
        self.commitCount = managedObject.commitCount
        self.repositoryName = managedObject.repositoryName
        self.commitMessages = managedObject.commitMessage
    }
    
    func store(in context: NSManagedObjectContext) {
        guard let note = NoteEntity.insertNew(in: context) else {
            return
        }
        note.id = id
        note.title = title
        note.date = date
        note.noteDescription = description
        note.commitCount = commitCount
        note.repositoryName = repositoryName
        note.commitMessage = commitMessages
    }
    
    func update(_ note: Note, in context: NSManagedObjectContext) {
        let fetchRequest =  NoteEntity.newFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", note.id)
        guard let updatedObject = try? context.fetch(fetchRequest).first else {
            return
        }
        updatedObject.setValue(title, forKey: NoteEntity.titleKey)
        updatedObject.setValue(date, forKey: NoteEntity.dateKey)
        updatedObject.setValue(description, forKey: NoteEntity.noteDescriptionKey)
        updatedObject.setValue(repositoryName, forKey: NoteEntity.repositoryName)
        updatedObject.setValue(commitMessages, forKey: NoteEntity.commitMessage)
    }
}
