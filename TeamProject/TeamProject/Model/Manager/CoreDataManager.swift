//
//  CoreDataManager.swift
//  TeamProject
//
//  Created by tlswo on 4/28/25.
//

import CoreData
import UIKit
import CoreLocation

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
    
    private init() { }
    
    // MARK: - Methods
    
    // MARK: - Methods - Save
    
    func saveKickboardRecord(record: KickBoardRecord) {
        let entity = KickBoardRecordEntity(context: context)
        entity.latitude = record.latitude
        entity.longitude = record.longitude
        entity.kickboardIdentifier = record.kickboardIdentifier
        entity.basicCharge = Int32(record.basicCharge)
        entity.hourlyCharge = Int32(record.hourlyCharge)
        entity.type = record.type
        entity.userID = record.userID
        
        saveContext()
    }
    
    func saveUsageHistory(record: KickBoardRecord, id: String) {
        let entity = UsageHistoryEntity(context: context)
        let now = Date()
        entity.kickboardIdentifier = record.kickboardIdentifier
        entity.useDate = now.toString(format: "yyyy.MM.dd")
        entity.startTime = now.toString(format: "HH:mm")
        entity.charge = 0
        entity.finishTime = nil
        entity.userID = id
        
        saveContext()
    }
    
    // MARK: - Methods - Update
    
    func updateUsageHistory(
        for identifier: UUID, distance: Double) -> UsageHistoryEntity? {guard let userID = UserManager.shared.getUser()?.id else {
        return nil
    }
        
        let fetchRequest: NSFetchRequest<UsageHistoryEntity> = UsageHistoryEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "userID == %@ AND kickboardIdentifier == %@ AND finishTime == nil",
            userID,
            identifier as CVarArg
        )
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "useDate", ascending: false),
            NSSortDescriptor(key: "startTime", ascending: false)
        ]
        fetchRequest.fetchLimit = 1
        
        guard let kickboardRecord = fetchRecord(with: identifier) else { return nil }
        
        do {
            if let entity = try context.fetch(fetchRequest).first {
                
                let finishTime = Date().toString(format: "HH:mm")
        
                let diff = Date.minutesBetween(entity.startTime, and: finishTime)
                
                entity.finishTime = finishTime
                entity.charge = Int32(kickboardRecord.basicCharge + kickboardRecord.hourlyCharge * diff)
                entity.distance = distance
                
                try context.save()
                return entity
            } else {
                print("업데이트할 UsageHistory가 없습니다.")
            }
        } catch {
            print("업데이트 중 에러: \(error.localizedDescription)")
        }
        return nil
    }
    
    // MARK: - Methods - Delete
    
    func deleteKickboardRecord(with identifier: UUID) {
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
    
    // MARK: - Methods - Fetch
    
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
                    hourlyCharge: Int(entity.hourlyCharge),
                    type: entity.type,
                    userID: entity.userID
                )
            }
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchRecord(with Id: UUID) -> KickBoardRecord? {
        let fetchRequest: NSFetchRequest<KickBoardRecordEntity> = KickBoardRecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "kickboardIdentifier == %@", Id as CVarArg)
        
        
        do {
            let results = try context.fetch(fetchRequest)
            if let target = results.first {
                return KickBoardRecord(latitude: target.latitude, longitude: target.longitude,
                                       
                                       kickboardIdentifier: target.kickboardIdentifier,
                                       basicCharge: Int(target.basicCharge), hourlyCharge: Int(target.hourlyCharge), type: target.type, userID: target.userID)
            }
        } catch {
            print("Fetch error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func fetchRecordsForCurrentUser() -> [KickBoardRecord] {
        guard let userID = UserManager.shared.getUser()?.id else {
            return []
        }
        
        let fetchRequest: NSFetchRequest<KickBoardRecordEntity> = KickBoardRecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.compactMap { entity -> KickBoardRecord in
                return KickBoardRecord(
                    latitude: entity.latitude,
                    longitude: entity.longitude,
                    kickboardIdentifier: entity.kickboardIdentifier,
                    basicCharge: Int(entity.basicCharge),
                    hourlyCharge: Int(entity.hourlyCharge),
                    type: entity.type,
                    userID: entity.userID
                )
            }
        } catch {
            print("error: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchAllUsageHistorys() -> [UsageHistory] {
        let request: NSFetchRequest<UsageHistoryEntity> = UsageHistoryEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { entity -> UsageHistory in
                //이미지 사용을 위한 킥보드 타입 정보 가져오기
                let kickboardRecord = fetchRecord(with: entity.kickboardIdentifier)
                
                return UsageHistory(
                    kickboardIdentifier: entity.kickboardIdentifier,
                    charge: Int(entity.charge),
                    finishTime: entity.finishTime,
                    startTime: entity.startTime,
                    useDate: entity.useDate,
                    userID: entity.userID,
                    distance: entity.distance,
                    type: kickboardRecord?.type ?? "A"
                )
            }
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchUsageHistorysForCurrentUser() -> [UsageHistory] {
        guard let userID = UserManager.shared.getUser()?.id else {
            return []
        }
        
        let fetchRequest: NSFetchRequest<UsageHistoryEntity> = UsageHistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.compactMap { entity -> UsageHistory in
                //이미지 사용을 위한 킥보드 타입 정보 가져오기
                let kickboardRecord = fetchRecord(with: entity.kickboardIdentifier)
                
                return UsageHistory(
                    kickboardIdentifier: entity.kickboardIdentifier,
                    charge: Int(entity.charge),
                    finishTime: entity.finishTime,
                    startTime: entity.startTime,
                    useDate: entity.useDate,
                    userID: entity.userID,
                    distance: entity.distance,
                    type: kickboardRecord?.type ?? "A"
                )
            }
        } catch {
            print("error: \(error.localizedDescription)")
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
