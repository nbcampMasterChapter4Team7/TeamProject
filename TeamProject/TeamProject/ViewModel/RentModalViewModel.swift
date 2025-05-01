//
//  RentModalViewModel.swift
//  TeamProject
//
//  Created by yimkeul on 4/29/25.
//

import Foundation

final class RentModalViewModel {
    
    // MARK: - Properties
    
    private let coreDataManager = CoreDataManager.shared
    static let shared = RentModalViewModel()
    var rentStartDate: Date?
    
    // MARK: - Methods
    
    func fetchKickBoardRecord(with Id: UUID) -> KickBoardRecord? {
        return coreDataManager.fetchRecord(with: Id)
    }
    
    func saveUsageHistory(with data: KickBoardRecord) {
        return coreDataManager.saveUsageHistory(record: data)
    }
    
    func updateUsageHistory(with id: UUID) -> UsageHistoryEntity? {
        let distance = RentViewModel.shared.calculateDistance(for: id)
        return coreDataManager.updateUsageHistory(for: id, distance: distance)
    }
}
