//
//  ViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit
import KakaoMapsSDK

final class ViewController: UIViewController, MapControllerDelegate {

    private var mapContainer: KMViewContainer!
    private var mapController: KMController!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapContainer = KMViewContainer(frame: view.bounds)
        mapContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapContainer)

        mapController = KMController(viewContainer: mapContainer)
        mapController.delegate = self

        mapController.prepareEngine()
    }

    func authenticationSucceeded() {
        let center = MapPoint(longitude: 127.0276, latitude: 37.4979)
        let mapViewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: center, defaultLevel: 7)
        mapController.addView(mapViewInfo)
    }

    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("인증 실패: \(errorCode) - \(desc)")
    }

    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        if let mapView = mapController.getView(viewName) as? KakaoMap {
            mapView.viewRect = mapContainer.bounds
        }
    }
    
    func addViews() {
        
    }
}
