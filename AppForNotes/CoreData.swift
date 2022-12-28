//
//  CoreData.swift
//  AppForNotes
//
//  Created by Julia on 28/12/2022.
//

import UIKit
import CoreData

final class CoreData {
    static let shared = CoreData()
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ModelCoreData")
        let databaseExists = FileManager.default.fileExists(atPath: container.persistentStoreDescriptions[0].url!.path)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        if !databaseExists  {
            let context = container.viewContext
            let object = Note(context: context, note: "Welcome to Notes!", date: Date())
            do {
                try context.save()
            } catch {
                fatalError("cannot save the object")
            }
        }
        return container
    }()
    
    var viewContext:NSManagedObjectContext { CoreData.shared.persistentContainer.viewContext }
    
    private init() {}
}


