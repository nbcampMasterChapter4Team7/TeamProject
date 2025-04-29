//
//  RentViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/28/25.
//

import CoreLocation
import UIKit

import SnapKit
import Then
import KakaoMapsSDK

final class RentViewController: KakaoMapViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    private let viewModel = RentViewModel.shared
    
    private let locationManager = CLLocationManager()
    
    // MARK: - UI Components

    private let locationButton = UIButton().then { make in
        let img = ImageLiterals.location.resize(newWidth: 32)
        make.setImage(img, for: .normal)
        make.backgroundColor = .white
        make.layer.cornerRadius = 25
    }
    
    private let samplePopUpModealButton = UIButton().then { make in
        make.setTitle("모달", for: .normal)
        make.backgroundColor = .white
        make.setTitleColor(UIColor.asset(.main), for: .normal)
        
    }
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setLocationService()
        setLayout()
        
        locationButton.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        samplePopUpModealButton.addTarget(self, action: #selector(didTapPingButton), for: .touchUpInside)
    }
    
    // 엔진이 준비·활성화된 직후에 지도 추가
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addViews()
        viewModel.fetchKickBoardRecords()
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        view.addSubviews(locationButton, samplePopUpModealButton)
        
        locationButton.snp.makeConstraints {
            $0.width.height.equalTo(53)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        samplePopUpModealButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.bringSubviewToFront(locationButton)
    }

    // MARK: - Methods
    
    private func setLocationService() {
        // 포그라운드일 때 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        
        // 배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 위치 업데이트
        locationManager.startUpdatingLocation()
    }
    
    private func setupBindings() {
        viewModel.onRecordsUpdated = { [weak self] records in
            guard self != nil else { return }
            guard let mapView = self?.mapController?.getView("mapview") as? KakaoMap else { return }
            guard let layer = mapView.getLabelManager().getLabelLayer(layerID: "PoiLayer") else { return }
                        
            for record in records {
                let position = MapPoint(longitude: record.longitude, latitude: record.latitude)
                let option = PoiOptions(styleID: "kickboardMarkStyleID")
                option.clickable = true

                if let poi = layer.addPoi(option: option, at: position) {
                    poi.show()
                }
            }
        }
    }
    
    override func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        print("<<")
        super.addViewSucceeded(viewName, viewInfoName: viewInfoName)
        setupBindings()
        viewModel.fetchKickBoardRecords()
    }
    
    // MARK: - @objc Methods
    
    /// 현재 위치 받아오는 버튼
    @objc private func didTapLocationButton() {
        
        // 위,경도 가져오기
        guard let coor = locationManager.location?.coordinate else {
            print("현재 위치를 받아올 수 없습니다.")
            setLocationService()
            return
        }
        
        let point = MapPoint(longitude: coor.longitude, latitude: coor.latitude)
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            print("지도 뷰를 찾을 수 없습니다.")
            return
        }
        let cameraUpdate = CameraUpdate.make(target: point, mapView: mapView)
        mapView.moveCamera(cameraUpdate)
        print("지도 중심을 (\(coor.longitude), \(coor.latitude)로 이동했습니다.")
    }
    
    @objc private func didTapPingButton() {
        let vc = RentModalViewController()
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

