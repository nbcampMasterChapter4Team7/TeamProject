//
//  CoreDataManager.swift
//  TeamProject
//
//  Created by tlswo on 4/28/25.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    // MARK: - Singleton Instance

    static let shared = CoreDataManager()
    
    // MARK: - Properties
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData load error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Initializer

    private init() {}
    
    // MARK: - Methods
    
    func save(record: KickBoardRecord) {
        let entity = KickBoardRecordEntity(context: context)
        entity.latitude = record.latitude
        entity.longitude = record.longitude
        entity.kickboardIdentifier = record.kickboardIdentifier
        entity.basicCharge = Int32(record.basicCharge)
        entity.hourlyCharge = Int32(record.hourlyCharge)
        
        saveContext()
    }
    
    func deleteRecord(with identifier: UUID) {
        let fetchRequest: NSFetchRequest<KickBoardRecordEntity> = KickBoardRecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "kickboardIdentifier == %@", identifier as CVarArg)

        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Delete error: \(error.localizedDescription)")
        }
    }
    
    func fetchAllRecords() -> [KickBoardRecord] {
        let request: NSFetchRequest<KickBoardRecordEntity> = KickBoardRecordEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { entity -> KickBoardRecord in
                return KickBoardRecord(
                    latitude: entity.latitude,
                    longitude: entity.longitude,
                    kickboardIdentifier: entity.kickboardIdentifier,
                    basicCharge: Int(entity.basicCharge),
                    hourlyCharge: Int(entity.hourlyCharge)
                )
            }
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            return []
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save context error: \(error.localizedDescription)")
            }
        }
    }
}
