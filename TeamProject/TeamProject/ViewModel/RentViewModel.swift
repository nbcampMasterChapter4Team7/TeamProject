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
    
    private(set) var currentLocation: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0) {
        didSet {
            onLocationUpdate?(currentLocation)
        }
    }
    
    private(set) var records: [KickBoardRecord] = [] {
        didSet {
            onRecordsUpdated?(records)
        }
    }
    
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    var onRecordsUpdated: (([KickBoardRecord]) -> Void)?
    
    // MARK: - Initializer
    
    private override init() {
        self.coreDataManager = CoreDataManager.shared
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
    
//    func fetchKickBoardRecords() {
//        let fetchedRecords = coreDataManager.fetchAllRecords()
//        self.records = fetchedRecords
//    }
    
    func fetchFilteredByDistanceKickBoardRecords(myLocation: Location, maxDistanceInKm: Double) {
        let fetchedRecords = coreDataManager.fetchAllRecords()

        self.records = fetchedRecords.filter { record in
            let kickboardLocation = Location(latitude: record.latitude, longitude: record.longitude)
            let distance = haversineDistance(from: myLocation, to: kickboardLocation)
            return distance <= maxDistanceInKm
        }
    }
    
    func haversineDistance(from start: Location, to end: Location) -> Double {
        let earthRadius = 6_371.0
        
        let startLatRad = start.latitude * .pi / 180
        let endLatRad = end.latitude * .pi / 180
        let deltaLat = (end.latitude - start.latitude) * .pi / 180
        let deltaLon = (end.longitude - start.longitude) * .pi / 180

        let a = sin(deltaLat / 2) * sin(deltaLat / 2) +
                cos(startLatRad) * cos(endLatRad) *
                sin(deltaLon / 2) * sin(deltaLon / 2)

        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        return earthRadius * c
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
//        guard let location = locations.last else { return }
//        let coord = location.coordinate
//        currentLocation = coord
//        onLocationUpdate?(coord)
        guard let last = locations.last else { return }
        currentLocation = last.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
    
}
