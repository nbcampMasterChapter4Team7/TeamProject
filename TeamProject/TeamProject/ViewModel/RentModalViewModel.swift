//
//  RentModalViewModel.swift
//  TeamProject
//
//  Created by yimkeul on 4/29/25.
//

import Foundation

final class RentModalViewModel {
    
    // MARK: - Singleton Instance
    
    static let shared = RentModalViewModel()
    
    // MARK: - Properties

    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Initializer
    
    private init () { }
    
    // MARK: - Methods
    
    func fetchKickBoardRecord(with Id: UUID) -> KickBoardRecord? {
        return  coreDataManager.fetchRecord(with: Id)
    }
}
