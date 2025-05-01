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
    private let kickBoardRecordVM = KickBoardRecordViewModel.shared

       
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setLayout()
        setupNavigationBar()
        setupViewModel()
    }
    
    // MARK: - Layout Helper
    
    private func setUp() {
        view.addSubview(registrationHistoryView)
    }
    
    private func setLayout() {
        registrationHistoryView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func setupNavigationBar() {
        navigationItem.title = "등록 내역"
    }
    
    // MARK: - Methods
    
    private func setupViewModel() {
        kickBoardRecordVM.onRegistrationHistoriesUpdated = { [weak self] histories in
            self?.registrationHistoryView.updateData(histories)
        }
        
        kickBoardRecordVM.fetchFilteredKickBoardRecords()
        kickBoardRecordVM.fetchRegistrationHistories()
    }
}
