//
//  UsageHistoryViewController.swift
//  TeamProject
//
//  Created by iOS study on 4/29/25.
//

import UIKit

import SnapKit

final class UsageHistoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private var usageHistoryView = UsageHistoryView()
    private let usageHistoryVM = UsageHistoryViewModel.shared
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setLayout()
        setupNavigationBar()
        setupViewModel()
        
        print(CoreDataManager.shared.fetchUsageHistorysForCurrentUser())
    }
    
    // MARK: - Layout Helper
    
    private func setUp() {
        view.addSubview(usageHistoryView)
    }
    
    private func setLayout() {
        usageHistoryView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "이용 내역"
    }
    
    // MARK: - Methods
    
    private func setupUsageHistoryView() {
        view.addSubview(usageHistoryView)
        usageHistoryView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupViewModel() {
        usageHistoryVM.onUsageHistoriesUpdated = { [weak self] histories in
            self?.usageHistoryView.updateData(histories)
        }
        usageHistoryVM.fetchUsageHistories()
    }
}
