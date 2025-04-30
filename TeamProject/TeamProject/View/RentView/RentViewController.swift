//
//  RentViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/28/25.
//

import CoreLocation
import UIKit

import KakaoMapsSDK
import SnapKit
import Then

final class RentViewController: KakaoMapViewController {

    // MARK: - Properties

    private let viewModel = RentViewModel.shared
    private var poiToRecordMap: [String: KickBoardRecord] = [:]
    private var isPoiVisible = true

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
        let origin = ImageLiterals.scooter.resize(newWidth: 32)
        let img = origin.withRenderingMode(.alwaysTemplate)
        make.tintColor = UserDefaultsManager.shared.isRent() ? UIColor.asset(.main) : .black
        make.setImage(img, for: .normal)
        make.backgroundColor = .white
        make.layer.cornerRadius = 25
    }

    override func viewDidLayoutSubviews() {
        searchBar.layoutIfNeeded()
                let searchTextField = searchBar.searchTextField
                searchTextField.layer.cornerRadius = searchTextField.frame.height / 2
    }
    
    private let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        $0.placeholder = "주소를 입력해주세요"
        $0.searchTextField.font = .systemFont(ofSize: 16)

        let spacer = UIView()
        spacer.frame.size.width = 8
        $0.searchTextField.leftView = spacer
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.borderStyle = .none
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
        setupRentStatusObserver()
    }

    // 엔진이 준비·활성화된 직후에 지도 추가
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addViews()
        showKickboardByCurrentLocation()
    }

    // MARK: - Action Helper


    private func setupAction() {
        locationButton.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        visibleKickboardButton.addTarget(self, action: #selector(didTapVisibleKickboardButton), for: .touchUpInside)
        returnKickboardButton.addTarget(self, action: #selector(didTapReturnKickboardButton), for: .touchUpInside)
    }

    // MARK: - Layout Helper

    private func setLayout() {
        view.addSubviews(locationButton, visibleKickboardButton, returnKickboardButton,
            searchBar)

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

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
        viewModel.onLocationUpdate = { [weak self] coord in
            guard let self = self else { return }

            // mapView가 아직 생성되지 않았다면 0.1초 뒤에 재시도
            guard let mapView = self.mapController?.getView("mapview") as? KakaoMap else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.viewModel.onLocationUpdate?(coord)
                }
                return
            }

            guard let layer = mapView.getLabelManager().getLabelLayer(layerID: "CurrentLocationLayer") else {
                return
            }

            let point = MapPoint(longitude: coord.longitude, latitude: coord.latitude)
            let cameraUpdate = CameraUpdate.make(target: point, mapView: mapView)
            mapView.moveCamera(cameraUpdate)

            layer.clearAllItems()
            let opt = PoiOptions(styleID: "currentLocationStyle")
            opt.clickable = false
            if let poi = layer.addPoi(option: opt, at: point) {
                poi.show()
            }
        }

        viewModel.onRecordsUpdated = { [weak self] records in

            guard let self = self,
                let mapView = self.mapController?.getView("mapview") as? KakaoMap,
                let layer = mapView.getLabelManager().getLabelLayer(layerID: "PoiLayer")
                else { return }

            layer.clearAllItems()
            self.poiToRecordMap.removeAll()

            records.forEach { record in
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
        if let mapView = mapController?.getView("mapview") as? KakaoMap {
            let coord = viewModel.currentLocation
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
        showKickboardByCurrentLocation()
        setupCurrentLocationToMap()
    }

    private func setupRentStatusObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRentStatusChanged),
            name: Notification.Name("rentStatusChanged"),
            object: nil
        )
    }

    private func showKickboardByCurrentLocation() {
        let point = viewModel.currentLocation
        viewModel.fetchFilteredByDistanceKickBoardRecords(myLocation: Location(latitude: point.latitude, longitude: point.longitude), maxDistanceInKm: 3)
    }

    private func updateReturnButtonTint() {
        let color: UIColor = UserDefaultsManager.shared.isRent()
            ? UIColor.asset(.main)
        : .black
        returnKickboardButton.tintColor = color
    }

    private func hideRentedPoi() {
        guard
            let mapView = mapController?.getView("mapview") as? KakaoMap,
            let layer = mapView.getLabelManager().getLabelLayer(layerID: "PoiLayer"),
            let rentedID = UserDefaultsManager.shared.getKickboardID()
            else { return }

        // poiToRecordMap 에서 rentedID에 해당하는 itemID를 찾아 레이어에서 제거
        if let poiIDToHide = poiToRecordMap.first(where: { $0.value.kickboardIdentifier.uuidString == rentedID })?.key {
            layer.removePoi(poiID: poiIDToHide)
            poiToRecordMap.removeValue(forKey: poiIDToHide)
        } else {
            print("poiID 숨기지 못함")
        }
    }

    // MARK: - @objc Methods

    /// 현재 위치 받아오는 버튼
    @objc private func didTapLocationButton() {
        self.setupCurrentLocationToMap()
    }

    @objc private func didTapVisibleKickboardButton() {
        guard
            let mapView = mapController?.getView("mapview") as? KakaoMap,
            let layer = mapView.getLabelManager().getLabelLayer(layerID: "PoiLayer")
            else { return }

        isPoiVisible.toggle()

        if isPoiVisible {
            // 다시 POI 추가
            showKickboardByCurrentLocation()
        } else {
            // POI 숨기기
            layer.clearAllItems()
        }
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

    @objc private func handleRentStatusChanged() {
        updateReturnButtonTint()

        if UserDefaultsManager.shared.isRent() {
            hideRentedPoi()
        } else {
            // 반납했을 때, 다시 보여주고 싶다면
            showKickboardByCurrentLocation()
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

