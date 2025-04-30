//
//  UsageHistoryEntity+CoreDataProperties.swift
//  TeamProject
//
//  Created by yimkeul on 4/30/25.
//
//

import Foundation
import CoreData


extension UsageHistoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsageHistoryEntity> {
        return NSFetchRequest<UsageHistoryEntity>(entityName: "UsageHistoryEntity")
    }

    @NSManaged public var kickboardIdentifier: UUID
    @NSManaged public var useDate: Date
    @NSManaged public var startTime: Date?
    @NSManaged public var finishTime: Date?
    @NSManaged public var charge: Int32

}

extension UsageHistoryEntity : Identifiable {

}
