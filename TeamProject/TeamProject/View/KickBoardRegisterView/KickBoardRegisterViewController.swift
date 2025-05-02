//
//  KickBoardRegisterViewController.swift
//  TeamProject
//
//  Created by tlswo on 4/28/25.
//

import UIKit

import KakaoMapsSDK

final class KickBoardRegisterViewController: KakaoMapViewController {
    
    // MARK: - Properties
    
    private var observerAdded: Bool
    private var appear: Bool
    private var isViewAdded = false
    private var lastAddedPoi: Poi?
    
    private let viewModel = KickBoardRecordViewModel.shared
    
    private var poiToRecordMap: [String: KickBoardRecord] = [:]
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        observerAdded = false
        appear = false
        super.init(coder: aDecoder)
        auth = false
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        observerAdded = false
        appear = false
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        auth = false
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        appear = true
        if mapController?.isEnginePrepared == false {
            mapController?.prepareEngine()
        }
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appear = false
        mapController?.pauseEngine() //렌더링 중지.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine() //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    // MARK: - Methods
    
    // 인증 성공시 delegate 호출.
    private func authenticationSucceeded() {
    
        // 일반적으로 내부적으로 인증과정 진행하여 성공한 경우 별도의 작업은 필요하지 않으나,
        // 네트워크 실패와 같은 이슈로 인증실패하여 인증을 재시도한 경우, 성공한 후 정지된 엔진을 다시 시작할 수 있다.
        if auth == false {
            auth = true
        }
        
        if appear && mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
        if !isViewAdded {
            addViews()
            isViewAdded = true
        }
    }
    
    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    override func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        super.addViewSucceeded(viewName, viewInfoName: viewInfoName)
        setupBindings()
        viewModel.fetchKickBoardRecords()
        setupCurrentLocationToMap()
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    private func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size) //지도뷰의 크기를 리사이즈된 크기로 지정한다.
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        observerAdded = true
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        observerAdded = false
    }
    
    private func setupBindings() {
        viewModel.onRecordsUpdated = { [weak self] records in
            guard let self else { return }
            guard let mapView = self.mapController?.getView("mapview") as? KakaoMap else { return }
            guard let layer = mapView.getLabelManager().getLabelLayer(layerID: "PoiLayer") else { return }

            layer.clearAllItems()
            self.poiToRecordMap.removeAll()

            for record in records {
                let styleID = "kickboardMarkStyleID_\(record.type)"
                let position = MapPoint(longitude: record.longitude, latitude: record.latitude)

                let option = PoiOptions(styleID: styleID)
                option.clickable = true

                if let poi = layer.addPoi(option: option, at: position) {
                    poi.show()
                    self.poiToRecordMap[poi.itemID] = record
                }
            }
        }
    }
    
    private func setupCurrentLocationToMap() {
        if let coord = viewModel.currentLocation,
            let mapView = mapController?.getView("mapview") as? KakaoMap {
             let point = MapPoint(longitude: coord.longitude, latitude: coord.latitude)
             let cameraUpdate = CameraUpdate.make(target: point, mapView: mapView)
             mapView.moveCamera(cameraUpdate)
         } else {
             viewModel.startUpdatingLocation()
         }
    }
    
    // MARK: - @objc Methods
    
    @objc func willResignActive() {
        mapController?.pauseEngine() //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
    }
    
    @objc func didBecomeActive() {
        mapController?.activateEngine() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
    }
}

// MARK: - Extension

extension KickBoardRegisterViewController {
    func terrainDidLongPressed(kakaoMap: KakaoMap, position: MapPoint) {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let option = PoiOptions(styleID: "kickboardMarkStyleID_A")
        option.clickable = true
        
        if let poi = layer?.addPoi(option: option, at: position) {
            poi.show()
            self.lastAddedPoi = poi
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self else { return }
                
                let alertVC = RegisterKickboardAlertViewController()
                alertVC.delegate = self
                alertVC.latitude = position.wgsCoord.latitude
                alertVC.longitude = position.wgsCoord.longitude
                alertVC.recognitionNumber = UUID()
                alertVC.modalPresentationStyle = .overFullScreen
                self.present(alertVC, animated: true)
            }
        }
    }
    
    func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        guard let record = poiToRecordMap[poiID] else {
            print("Record not found for tapped POI")
            return
        }
        
        let id = UserManager.shared.getUser()?.id
        if record.userID != id {
            return
        }
        
        print("Tapped record: \(record)")
        
        let vc = DeleteModalViewController(
            kickboardID: record.kickboardIdentifier,
            basicCharge: record.basicCharge,
            hourlyCharge: record.hourlyCharge,
            kickboardType: record.type
        )
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _  in
                return SizeLiterals.Screen.screenHeight * 257 / 874
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        present(vc, animated: true, completion: nil)
    }
}

extension KickBoardRegisterViewController: RegisterKickboardAlertDelegate {
    func didCancelRegister() {
        lastAddedPoi?.hide()
        lastAddedPoi = nil
    }
}
