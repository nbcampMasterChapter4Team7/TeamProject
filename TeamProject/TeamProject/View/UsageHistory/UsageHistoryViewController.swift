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
       
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUsageHistoryView()
        print(CoreDataManager.shared.fetchAllUsageHistorys())
    }
    
    // MARK: - Methods
    
    private func setupNavigationBar() {
        navigationItem.title = "이용 내역"
    }
    
    private func setupUsageHistoryView() {
        view.addSubview(usageHistoryView)
        usageHistoryView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
