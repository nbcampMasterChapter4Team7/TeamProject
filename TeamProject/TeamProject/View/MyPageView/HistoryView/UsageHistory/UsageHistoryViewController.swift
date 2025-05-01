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
        setupViewModel()

        print(CoreDataManager.shared.fetchUsageHistorysForCurrentUser())
    }
    
    // MARK: - Methods
    
    private func setupNavigationBar() {
        navigationItem.title = "이용 내역"
    }
    
    private func setupUsageHistoryView() {
        view.addSubview(usageHistoryView)
        usageHistoryView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // TODO: 현재는 이용 내역 VM이 없어서 등록 내역을 가져와서 출력(추후 해당 내용 수정)
    private func setupViewModel() {
        let histories = CoreDataManager.shared.fetchUsageHistorysForCurrentUser()
        usageHistoryView.updateData(histories)
    }
}
