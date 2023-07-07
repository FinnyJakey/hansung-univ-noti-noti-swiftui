//
//  PersistenceController.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/23.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = true) { // TODO: Bool = false
        container = NSPersistentContainer(name: "Favorite")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error {
                print("Could not load Core Data persistence stores.", error.localizedDescription)
                fatalError()
            }
        }
    }
    
    func saveChanges() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Could not save changes to Core Data.", error.localizedDescription)
            }
        }
    }
    
    func create(id: String, title: String, link: String, pubDate: String, author: String, category: String, description_s: String) {
        let entity = Favorite(context: container.viewContext)
        
        entity.id = id
        entity.title = title
        entity.link = link
        entity.pubDate = pubDate
        entity.author = author
        entity.category = category
        entity.description_s = description_s

        saveChanges()
    }
    
    func read(predicateFormat: String? = nil, fetchLimit: Int? = nil) -> [Favorite] {
        // create a temp array to save fetched notes
        var results: [Favorite] = []
        // initialize the fetch request
        let request = NSFetchRequest<Favorite>(entityName: "Favorite")

        // define filter and/or limit if needed
        if predicateFormat != nil {
            request.predicate = NSPredicate(format: predicateFormat!)
        }
        if fetchLimit != nil {
            request.fetchLimit = fetchLimit!
        }

        // fetch with the request
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch favorites from Core Data.")
        }

        // return results
        return results
    }
    
    func delete(_ entity: Favorite) {
        container.viewContext.delete(entity)
        
        saveChanges()
    }
}
