//
//  RentViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/28/25.
//

import UIKit

import SnapKit
import Then
import KakaoMapsSDK

final class RentViewController: KakaoMapViewController {

    private let locationButton = UIButton().then {
        let img = ImageLiterals.location.resize(newWidth: 32)
        $0.setImage(img, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
    }
    
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }

    // 엔진이 준비·활성화된 직후에 지도 추가
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addViews()
    }

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

    @objc private func didTapLocationButton() {
        let point = MapPoint(longitude: 126.9763, latitude: 37.5867)
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            print("지도 뷰를 찾을 수 없습니다.")
            return
        }
        let cameraUpdate = CameraUpdate.make(target: point, mapView: mapView)
        mapView.moveCamera(cameraUpdate)
        print("지도 중심을 (37.5867, 126.9763)로 이동했습니다.")
    }
}

