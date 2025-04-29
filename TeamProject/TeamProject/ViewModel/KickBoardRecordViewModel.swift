//
//  KickBoardRecordViewModel.swift
//  TeamProject
//
//  Created by tlswo on 4/28/25.
//

import Foundation

final class KickBoardRecordViewModel {
    
    // MARK: - Singleton Instance
    
    static let shared = KickBoardRecordViewModel()
    
    // MARK: - Properties
    
    private let coreDataManager: CoreDataManager
    
    private(set) var records: [KickBoardRecord] = [] {
        didSet {
            onRecordsUpdated?(records)
        }
    }
    
    var onRecordsUpdated: (([KickBoardRecord]) -> Void)?
    
    // MARK: - Initializer
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Methods
    
    func fetchKickBoardRecords() {
        let fetchedRecords = coreDataManager.fetchAllRecords()
        self.records = fetchedRecords
    }
    
    func saveKickBoardRecord(_ record: KickBoardRecord) {
        coreDataManager.save(record: record)
        fetchKickBoardRecords()
    }
    
    func deleteKickBoardRecord(_ identifier: UUID) {
        coreDataManager.deleteRecord(with: identifier)
        fetchKickBoardRecords()
    }
}
