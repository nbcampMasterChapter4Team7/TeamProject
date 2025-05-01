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
    private let kakaoRestAPIKey = Bundle.main
        .object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String ?? ""

    private var searchResults: [Document] = []


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

    private let resultsTableView = UITableView().then {
        $0.isHidden = true // 초기에는 숨김
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        $0.tableFooterView = UIView() // 빈 셀 구분선 제거
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

        searchBar.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
    }

    // 엔진이 준비·활성화된 직후에 지도 추가
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addViews()
        let point = viewModel.currentLocation
        showKickboardByCurrentLocation(latitude: point.latitude, longtitude: point.longitude)
    }

    // MARK: - Action Helper


    private func setupAction() {
        locationButton.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        visibleKickboardButton.addTarget(self, action: #selector(didTapVisibleKickboardButton), for: .touchUpInside)
        returnKickboardButton.addTarget(self, action: #selector(didTapReturnKickboardButton), for: .touchUpInside)
    }

    // MARK: - Layout Helper

    private func setLayout() {

        view.addSubviews(searchBar, resultsTableView,
            locationButton, visibleKickboardButton, returnKickboardButton)

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        resultsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(0) // 초기 높이는 0으로 두고, 결과가 있으면 높이 업데이트
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

//            let rentedID = UserDefaultsManager.shared.getKickboardID()

            layer.clearAllItems()
            self.poiToRecordMap.removeAll()



            records.forEach { record in
                
//                if let rentedID = rentedID,
//                    record.kickboardIdentifier.uuidString == rentedID {
//                    return
//                }

                let styleID = "kickboardMarkStyleID_\(record.type)"
                let position = MapPoint(longitude: record.longitude, latitude: record.latitude)
                let option = PoiOptions(styleID: styleID)
                option.clickable = true

                if let poi = layer.addPoi(option: option, at: position) {
                    poi.show()
                    self.poiToRecordMap[poi.itemID] = record
                    print("UPDATE : \(poi.itemID) - \(record.kickboardIdentifier)")
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
            self.showKickboardByCurrentLocation(latitude: coord.latitude, longtitude: coord.longitude)
        } else {
            viewModel.startUpdatingLocation()
        }
    }

    override func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        super.addViewSucceeded(viewName, viewInfoName: viewInfoName)
        setupBindings()
        let point = viewModel.currentLocation
        showKickboardByCurrentLocation(latitude: point.latitude, longtitude: point.longitude)
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

    private func showKickboardByCurrentLocation(latitude: Double, longtitude: Double) {

        viewModel.fetchFilteredByDistanceKickBoardRecords(myLocation: Location(latitude: latitude, longitude: longtitude), maxDistanceInKm: 3)
//        hideRentedPoi()
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
        print("hidden Target : \(rentedID)")
        // poiToRecordMap 에서 rentedID에 해당하는 itemID를 찾아 레이어에서 제거
        if let poiIDToHide = poiToRecordMap.first(where: { $0.value.kickboardIdentifier.uuidString == rentedID })?.key {
            layer.removePoi(poiID: poiIDToHide)
            poiToRecordMap.removeValue(forKey: poiIDToHide)
        } else {
            
            print("poiID 숨기지 못함")
        }
    }


    private func searchKeyword(_ query: String) {
        guard
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://dapi.kakao.com/v2/local/search/keyword.json?query=\(encodedQuery)"),
            let apiKey = kakaoRestAPIKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            else {
            print("URL 생성 실패")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("네트워크 에러:", error)
                return
            }
            guard let data = data else {
                print("응답 데이터 없음")
                return
            }

            do {
                let resp = try JSONDecoder().decode(SearchData.self, from: data)
                print("검색어: \(query), 결과 개수: \(resp.documents.count)")
                for doc in resp.documents.prefix(5) {
                    print("""
                        • \(doc.placeName)
                          도로명: \(doc.roadAddressName)
                          지번: \(doc.addressName)
                          좌표: (\(doc.x), \(doc.y))
                        """)
                }
                DispatchQueue.main.async {
                    self.searchResults = resp.documents
                    self.resultsTableView.reloadData()

                    // 테이블뷰 보이기 & 높이 조정 (예: 최대 5행)
                    let rowHeight: CGFloat = 50
                    let count = min(self.searchResults.count, 5)
                    self.resultsTableView.isHidden = count == 0
                    self.resultsTableView.snp.updateConstraints { make in
                        make.height.equalTo(rowHeight * CGFloat(count))
                    }
                }
            } catch let decodeError as DecodingError {
                // 디코딩 에러 종류별로 자세히 출력
                print("디코딩 에러:", decodeError)
                if let jsonStr = String(data: data, encoding: .utf8) {
                    print("응답 JSON:\n", jsonStr)
                }
            } catch {
                print("알 수 없는 에러:", error)
            }
        }.resume()
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
            let point = viewModel.currentLocation
            showKickboardByCurrentLocation(latitude: point.latitude, longtitude: point.longitude)
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

//        if UserDefaultsManager.shared.isRent() {
//            hideRentedPoi()
//        } else {
//            // 반납했을 때, 다시 보여주고 싶다면
//            let point = viewModel.currentLocation
//            showKickboardByCurrentLocation(latitude: point.latitude, longtitude: point.longitude)
//        }
    }
}
// MARK: - Extension

extension RentViewController {
    func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        guard let record = poiToRecordMap[poiID] else {
            print("Record not found for tapped POI")
            return
        }

        print("Tap : \(poiID) - \(record.kickboardIdentifier)")

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

extension RentViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count >= 2 else {

            // 2자 미만이면 결과 숨기기
            searchResults.removeAll()
            resultsTableView.reloadData()
            resultsTableView.isHidden = true

            return
        }
        searchKeyword(searchText)
    }
}

extension RentViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let doc = searchResults[indexPath.row]
        cell.textLabel?.text = doc.placeName
        cell.detailTextLabel?.text = doc.roadAddressName.isEmpty
            ? doc.addressName
        : doc.roadAddressName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let doc = searchResults[indexPath.row]
        guard
            let longtitue = Double(doc.x),
            let latitude = Double(doc.y),
            let mapView = mapController?.getView("mapview") as? KakaoMap
            else { return }

        searchBar.text = doc.placeName
        // (원한다면 키보드도 내리기)
        searchBar.resignFirstResponder()


        // 1) 지도 카메라 이동
        let point = MapPoint(longitude: longtitue, latitude: latitude)
        let cameraUpdate = CameraUpdate.make(target: point, mapView: mapView)
        mapView.moveCamera(cameraUpdate)

        showKickboardByCurrentLocation(latitude: latitude, longtitude: longtitue)
        // 2) 테이블뷰 숨기기
        resultsTableView.isHidden = true
    }
}
