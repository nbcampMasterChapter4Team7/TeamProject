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
    
    // TODO: 현재는 이용 내역 VM이 없어서 등록 내역을 가져와서 출력(추후 해당 내용 수정)
    private let viewModel = KickBoardRecordViewModel.shared
       
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUsageHistoryView()
        
        // TODO: 현재는 이용 내역 VM이 없어서 등록 내역을 가져와서 출력(추후 해당 내용 수정)
        setupViewModel()
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
        viewModel.onRecordsUpdated = { [weak self] records in
            // 레코드를 UsageHistory 형식으로 변환
            let usageHistories = records.map { record in
                // 현재 날짜와 시간 포맷팅
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                
                let currentDate = Date()
                let dateString = dateFormatter.string(from: currentDate)
                let timeString = timeFormatter.string(from: currentDate)
                
                return UsageHistory(
                    kickboardId: record.kickboardIdentifier.uuidString.prefix(6).uppercased(),
                    startTime: timeString,
                    endTime: timeString, // 실제로는 종료 시간을 따로 저장해야 함
                    distance: 0.5, // 실제 거리 계산 필요
                    date: dateString,
                    price: record.basicCharge
                )
            }
            
            self?.usageHistoryView.updateData(usageHistories)
        }
        
        viewModel.fetchKickBoardRecords()
    }
}
