//
//  KickBoardRecordEntity+CoreDataProperties.swift
//  TeamProject
//
//  Created by yimkeul on 4/29/25.
//
//

import Foundation
import CoreData


extension KickBoardRecordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KickBoardRecordEntity> {
        return NSFetchRequest<KickBoardRecordEntity>(entityName: "KickBoardRecordEntity")
    }

    @NSManaged public var basicCharge: Int32
    @NSManaged public var hourlyCharge: Int32
    @NSManaged public var kickboardIdentifier: UUID
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var poiId: String

}

extension KickBoardRecordEntity : Identifiable {

}
