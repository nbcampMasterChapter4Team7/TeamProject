//
//  RentViewModel.swift
//  TeamProject
//
//  Created by yimkeul on 4/29/25.
//

import Foundation

final class RentViewModel {
    
    // MARK: - Singleton Instance
    
    static let shared = RentViewModel()
    
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
}
