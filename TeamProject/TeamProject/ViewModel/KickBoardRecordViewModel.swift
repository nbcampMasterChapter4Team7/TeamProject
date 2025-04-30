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
    
    var onRecordsUpdated: (([KickBoardRecord]) -> Void)?
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    
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
