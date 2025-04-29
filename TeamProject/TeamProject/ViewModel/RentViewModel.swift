//
//  RentViewModel.swift
//  TeamProject
//
//  Created by yimkeul on 4/29/25.
//

import Foundation
import CoreLocation

final class RentViewModel: NSObject {
    
    // MARK: - Singleton Instance
    
    static let shared = RentViewModel()
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()

    private let coreDataManager: CoreDataManager
    
    private(set) var currentLocation: CLLocationCoordinate2D?
    
    private(set) var records: [KickBoardRecord] = [] {
        didSet {
            onRecordsUpdated?(records)
        }
    }
    
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    var onRecordsUpdated: (([KickBoardRecord]) -> Void)?
    
    // MARK: - Initializer
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
        super.init()
        locationManager.delegate = self
        
    }
    
    // MARK: - Methods
    
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func fetchKickBoardRecords() {
        let fetchedRecords = coreDataManager.fetchAllRecords()
        self.records = fetchedRecords
    }
}

extension RentViewModel: CLLocationManagerDelegate {
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
