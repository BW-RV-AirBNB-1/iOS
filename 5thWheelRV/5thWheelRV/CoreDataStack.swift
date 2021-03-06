//
//  CoreDataStack.swift
//  
//
//  Created by Lambda_School_Loaner_268 on 3/3/20.
//

import Foundation
import CoreData

class CoreDataStack {

    // MARK: - Properties
    lazy var container: NSPersistentContainer = {
        // The name below should match the filename of the xcdatamodeld file exactly (minus the extension)
        let container = NSPersistentContainer(name: "Listing")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    static let shared = CoreDataStack()
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    // MARK: - Methods
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Unable to save context: \(error)")
                context.reset()
            }
        }
    }
}
