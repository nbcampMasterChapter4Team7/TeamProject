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

final class RentViewController: KakaoMapViewController {

    // MARK: - Properties
    private let viewModel = RentViewModel.shared

    // MARK: - UI Components

    private let locationButton = UIButton().then { make in
        let img = ImageLiterals.location.resize(newWidth: 32)
        make.setImage(img, for: .normal)
        make.backgroundColor = .white
        make.layer.cornerRadius = 25
    }

    // MARK: - View Life Cycle

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.startUpdatingLocation()
        setLayout()
        setupAction()
    }

    // 엔진이 준비·활성화된 직후에 지도 추가
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addViews()
        viewModel.fetchKickBoardRecords()
    }
    
    // MARK: - Action Helper
    
    private func setupAction() {
        locationButton.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
    }

    // MARK: - Layout Helper

    private func setLayout() {
        view.addSubview(locationButton)

        locationButton.snp.makeConstraints {
            $0.width.height.equalTo(53)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.bringSubviewToFront(locationButton)
    }

    // MARK: - Methods

    private func setupBindings() {
        viewModel.onLocationUpdate = { [weak self] coor in
            guard let self = self, let mapView = self.mapController?.getView("mapview") as? KakaoMap else { return }

            let point = MapPoint(longitude: coor.longitude, latitude: coor.latitude)
            let cameraUpdate = CameraUpdate.make(target: point, mapView: mapView)
            mapView.moveCamera(cameraUpdate)
        }

        viewModel.onRecordsUpdated = { [weak self] records in
            guard let self = self,
                  let mapView = self.mapController?.getView("mapview") as? KakaoMap,
                  let layer = mapView.getLabelManager().getLabelLayer(layerID: "PoiLayer") else { return }
            
            records.forEach { record in
                let position = MapPoint(longitude: record.longitude, latitude: record.latitude)
                let option = PoiOptions(styleID: "kickboardMarkStyleID")
                option.clickable = true
                layer.addPoi(option: option, at: position)?.show()
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

    override func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        super.addViewSucceeded(viewName, viewInfoName: viewInfoName)
        setupBindings()
        viewModel.fetchKickBoardRecords()
        setupCurrentLocationToMap()
        
    }

    // MARK: - @objc Methods

    /// 현재 위치 받아오는 버튼
    @objc private func didTapLocationButton() {
        self.setupCurrentLocationToMap()
    }

    @objc private func didTapPingButton() {
        let vc = RentModalViewController()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in
                return SizeLiterals.Screen.screenHeight * 257 / 874
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        present(vc, animated: true, completion: nil)
    }
}
// MARK: - Extension

extension RentViewController {
    func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        print("Tap - \(layerID) - \(poiID) - \(position.wgsCoord.latitude) : \(position.wgsCoord.longitude)")
        let vc = RentModalViewController()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in
                return SizeLiterals.Screen.screenHeight * 257 / 874
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        present(vc, animated: true, completion: nil)
        
    }
}
