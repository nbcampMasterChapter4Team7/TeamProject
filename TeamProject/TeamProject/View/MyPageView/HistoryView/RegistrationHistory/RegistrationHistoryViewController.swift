//
//  RegistrationHistoryViewController.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//

import UIKit

import SnapKit

final class RegistrationHistoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private var registrationHistoryView = RegistrationHistoryView()
    private let KickBoardRecordVM = KickBoardRecordViewModel.shared

       
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegistrationHistoryView()
        setupNavigationBar()
        setupViewModel()
    }
    
    // MARK: - Methods
    
    private func setupNavigationBar() {
        navigationItem.title = "등록 내역"
    }
    
    private func setupRegistrationHistoryView() {
        view.addSubview(registrationHistoryView)
        registrationHistoryView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupViewModel() {
        KickBoardRecordVM.onRegistrationHistoriesUpdated = { [weak self] histories in
            self?.registrationHistoryView.updateData(histories)
        }
        
        KickBoardRecordVM.fetchFilteredKickBoardRecords()
        KickBoardRecordVM.fetchRegistrationHistories()
    }
}
