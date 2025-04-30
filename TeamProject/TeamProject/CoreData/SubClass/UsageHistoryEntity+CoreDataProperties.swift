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

    @NSManaged public var charge: Int32
    @NSManaged public var finishTime: String?
    @NSManaged public var kickboardIdentifier: UUID
    @NSManaged public var startTime: String
    @NSManaged public var useDate: String
    @NSManaged public var userID: String

}

extension UsageHistoryEntity : Identifiable {

}
