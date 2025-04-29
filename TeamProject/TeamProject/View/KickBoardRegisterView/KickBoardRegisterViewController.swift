//
//  KickBoardRegisterViewController.swift
//  TeamProject
//
//  Created by tlswo on 4/28/25.
//


import UIKit

import KakaoMapsSDK

class KickBoardRegisterViewController: KakaoMapViewController {
    
    required init?(coder aDecoder: NSCoder) {
        _observerAdded = false
        _appear = false
        super.init(coder: aDecoder)
        auth = false
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        _observerAdded = false
        _appear = false
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        auth = false
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
        
        print("deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        if mapController?.isEnginePrepared == false {
            mapController?.prepareEngine()
        }
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()  //렌더링 중지.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    // 인증 성공시 delegate 호출.
    func authenticationSucceeded() {
        // 일반적으로 내부적으로 인증과정 진행하여 성공한 경우 별도의 작업은 필요하지 않으나,
        // 네트워크 실패와 같은 이슈로 인증실패하여 인증을 재시도한 경우, 성공한 후 정지된 엔진을 다시 시작할 수 있다.
        if auth == false {
            auth = true
        }
        
        if _appear && mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
        if !isViewAdded {
            addViews()
            isViewAdded = true
        }
    }
    
    override func addViews() {
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
        mapController?.addView(mapviewInfo)
        
    }
    
    func viewInit(viewName: String) {
        print("OK")
    }
    
    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    override func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        print("AddView succeeded: \(viewName), \(viewInfoName)")
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = mapViewContainer!.bounds    //뷰 add 도중에 resize 이벤트가 발생한 경우 이벤트를 받지 못했을 수 있음. 원하는 뷰 사이즈로 재조정.
        view.eventDelegate = self
        createLabelLayer()
        createPoiStyle()
        viewInit(viewName: viewName)
    }
    
    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    override func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("AddView failed: \(viewName), \(viewInfoName)")
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = true
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = false
    }
    
    @objc func willResignActive(){
        mapController?.pauseEngine()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
    }
    
    @objc func didBecomeActive(){
        mapController?.activateEngine() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
    }
    
    var _observerAdded: Bool
    var _appear: Bool
    var isViewAdded = false
    var lastAddedPoi: Poi?
    
    // MARK: - Map Setup Helpers
    private func createLabelLayer() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        
        let layerOption = LabelLayerOptions(
            layerID: "PoiLayer",
            competitionType: .none,
            competitionUnit: .symbolFirst,
            orderType: .rank,
            zOrder: 10
        )
        _ = manager.addLabelLayer(option: layerOption)
    }
    
    private func createPoiStyle() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        
        if let originalImage = UIImage(named: "kickboard") {
            let targetSize = CGSize(width: 30, height: 30)
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            let resizedImage = renderer.image { _ in
                originalImage.draw(in: CGRect(origin: .zero, size: targetSize))
            }
            
            let iconStyle = PoiIconStyle(
                symbol: resizedImage,
                anchorPoint: CGPoint(x: 0.5, y: 1.0)
            )

            let poiStyle = PoiStyle(styleID: "kickboardMarkStyleID", styles: [
                PerLevelPoiStyle(iconStyle: iconStyle, level: 5),
            ])
            
            manager.addPoiStyle(poiStyle)
        } else {
            print("kickboard 이미지 로드 실패")
        }
    }
}

extension KickBoardRegisterViewController: KakaoMapEventDelegate {
    func terrainDidLongPressed(kakaoMap: KakaoMap, position: MapPoint) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let option = PoiOptions(styleID: "kickboardMarkStyleID")
        option.clickable = true
        
        if let poi = layer?.addPoi(option: option, at: position) {
            poi.show()
            self.lastAddedPoi = poi
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            let alertVC = RegisterKickboardAlertViewController()
            alertVC.delegate = self
            alertVC.latitude = position.wgsCoord.latitude
            alertVC.longitude = position.wgsCoord.longitude
            alertVC.recognitionNumber = UUID().uuidString
            alertVC.modalPresentationStyle = .overFullScreen
            self.present(alertVC, animated: true)
        }
    }
}

extension KickBoardRegisterViewController: RegisterKickboardAlertDelegate {
    func didCancelRegister() {
        lastAddedPoi?.hide()
        lastAddedPoi = nil
    }
}
