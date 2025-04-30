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

    private var poiToRecordMap: [String: KickBoardRecord] = [:]

    // MARK: - UI Components

    private let locationButton = UIButton().then { make in
        let img = ImageLiterals.location.resize(newWidth: 32)
        make.setImage(img, for: .normal)
        make.backgroundColor = .white
        make.layer.cornerRadius = 25
    }

    private let visibleKickboardButton = UIButton().then { make in
        let img = ImageLiterals.ping.resize(newWidth: 32)
        make.setImage(img, for: .normal)
        make.backgroundColor = .white
        make.layer.cornerRadius = 25
    }

    private let returnKickboardButton = UIButton().then { make in
        let img = ImageLiterals.scooter.resize(newWidth: 32)
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
        returnKickboardButton.addTarget(self, action: #selector(didTapReturnKickboardButton), for: .touchUpInside)
    }

    // MARK: - Layout Helper

    private func setLayout() {
        view.addSubviews(locationButton, visibleKickboardButton, returnKickboardButton)

        locationButton.snp.makeConstraints {
            $0.width.height.equalTo(53)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        visibleKickboardButton.snp.makeConstraints {
            $0.width.height.equalTo(53)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(locationButton.snp.top).offset(-16)
        }

        returnKickboardButton.snp.makeConstraints {
            $0.width.height.equalTo(53)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(visibleKickboardButton.snp.top).offset(-16)
        }

        view.bringSubviewToFront(locationButton)
        view.bringSubviewToFront(visibleKickboardButton)
        view.bringSubviewToFront(returnKickboardButton)
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

            layer.clearAllItems()

            records.forEach { record in
                let position = MapPoint(longitude: record.longitude, latitude: record.latitude)
                let option = PoiOptions(styleID: "kickboardMarkStyleID")
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

    @objc private func didTapReturnKickboardButton() {
        guard let kickboardID = UserDefaultsManager.shared.getKickboardID(),
            let uuid = UUID(uuidString: kickboardID) else { return }
        let vc = RentModalViewController(kickboardId: uuid)
        
        if !UserDefaultsManager.shared.isRent() {
            showAlert(title: "알림", message: "대여한 킥보드가 없습니다.")
        } else {
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
}
// MARK: - Extension

extension RentViewController {
    func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        guard let record = poiToRecordMap[poiID] else {
            print("Record not found for tapped POI")
            return
        }
        let vc = RentModalViewController(kickboardId: record.kickboardIdentifier)

        if UserDefaultsManager.shared.isRent() {
            showAlert(title: "알림", message: "킥보드를 대여중 입니다.")
        } else {
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
}
