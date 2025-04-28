//
//  RentViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/28/25.
//

import UIKit
import CoreLocation

import SnapKit
import Then
import KakaoMapsSDK

final class RentViewController: KakaoMapViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    
    // MARK: - UI Components

    private let locationButton = UIButton().then {
        let img = ImageLiterals.location.resize(newWidth: 32)
        $0.setImage(img, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
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
    }
    
    // 엔진이 준비·활성화된 직후에 지도 추가
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addViews()
    }
    
    private func setLocationService() {
        // 포그라운드일 때 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        
        // 배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 위치 업데이트
        locationManager.startUpdatingLocation()
    }

    // MARK: - Layout Helper
    
    private func setLayout() {
        view.addSubview(locationButton)
        locationButton.snp.makeConstraints {
            $0.width.height.equalTo(53)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        locationButton.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        view.bringSubviewToFront(locationButton)
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
}

