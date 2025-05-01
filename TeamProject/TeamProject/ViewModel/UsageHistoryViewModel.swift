//
//  UsageHistoryViewModel.swift
//  TeamProject
//
//  Created by iOS study on 5/1/25.
//

final class UsageHistoryViewModel {
    // MARK: - Singleton Instance
    
    static let shared = UsageHistoryViewModel()
    
    // MARK: - Properties
    
    private let coreDataManager: CoreDataManager
    
    private(set) var usageHistories: [UsageHistory] = [] {
        didSet {
            onUsageHistoriesUpdated?(usageHistories)
        }
    }
    
    var onUsageHistoriesUpdated: (([UsageHistory]) -> Void)?
    
    // MARK: - Initializer
    
    private init() {
        self.coreDataManager = CoreDataManager.shared
    }
    
    // MARK: - Methods
    
    func fetchUsageHistories() {
        let histories = coreDataManager.fetchUsageHistorysForCurrentUser()
        self.usageHistories = histories
    }
}
