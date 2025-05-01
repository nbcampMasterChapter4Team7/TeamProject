//
//  KickBoardRecordViewModel.swift
//  TeamProject
//
//  Created by tlswo on 4/28/25.
//

import Foundation
import CoreLocation

final class KickBoardRecordViewModel: NSObject {
    
    // MARK: - Singleton Instance
    
    static let shared = KickBoardRecordViewModel()
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    
    private let coreDataManager: CoreDataManager
    
    private(set) var currentLocation: CLLocationCoordinate2D?
    
    private(set) var records: [KickBoardRecord] = [] {
        didSet {
            onRecordsUpdated?(records)
        }
    }
    
    // RegistrationHistory에서 사용을 위한 추가
    private(set) var registrationHistories: [RegistrationHistory] = [] {
        didSet {
            onRegistrationHistoriesUpdated?(registrationHistories)
        }
    }
    
    var onRecordsUpdated: (([KickBoardRecord]) -> Void)?
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    var onRegistrationHistoriesUpdated: (([RegistrationHistory]) -> Void)?
    
    // MARK: - Initializer
    
    private override init() {
        self.coreDataManager = CoreDataManager.shared
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Methods
    
    func fetchKickBoardRecords() {
        let fetchedRecords = coreDataManager.fetchAllRecords()
        self.records = fetchedRecords
    }
    
    func fetchFilteredKickBoardRecords() {
        let fetchedRecords = coreDataManager.fetchRecordsForCurrentUser()
        self.records = fetchedRecords
        print("###########################")
        print(self.records)
    }
    
    func saveKickBoardRecord(_ record: KickBoardRecord) {
        coreDataManager.save(record: record)
        fetchKickBoardRecords()
    }
    
    func deleteKickBoardRecord(_ identifier: UUID) {
        coreDataManager.deleteRecord(with: identifier)
        fetchKickBoardRecords()
    }
    
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // RegistrationHistory 데이터를 처리하고, RegistrationHistoryView에서 표시할 수 있도록 메소드 작성
    func fetchRegistrationHistories() {
        let histories = records.map { record in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            
            return RegistrationHistory(
                kickboardId: record.kickboardIdentifier.uuidString.prefix(8).uppercased(),
                basicFee: record.basicCharge,
                hourlyFee: record.hourlyCharge,
                date: dateFormatter.string(from: Date()),
                type: record.type
            )
        }
        
        self.registrationHistories = histories
    }
}

extension KickBoardRecordViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coord = location.coordinate
        currentLocation = coord
        onLocationUpdate?(coord)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
    
}
