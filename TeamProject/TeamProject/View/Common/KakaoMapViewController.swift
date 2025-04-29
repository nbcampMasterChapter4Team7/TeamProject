//
//  KakaoMapViewController.swift
//  TeamProject
//
//  Created by yimkeul on 4/28/25.
//

import UIKit
import KakaoMapsSDK

/**
 -KakaoMapViewController : KakaoMap의 뷰트롤러 관리
 */
class KakaoMapViewController: UIViewController, MapControllerDelegate, KakaoMapEventDelegate {

    // MARK: - Properties
    var mapViewContainer: KMViewContainer!
    var mapController: KMController!
    var auth: Bool = false

    // MARK: - Lifecycle
    override func loadView() {
        mapViewContainer = KMViewContainer(frame: UIScreen.main.bounds)
        self.view = mapViewContainer

        mapController = KMController(viewContainer: mapViewContainer)
        mapController?.delegate = self

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeMap()
    }

    /// 맵 엔진을 정리하는 작업
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()

        print("deinit")
    }

    // MARK: - Map Initializers
    /// 맵 초기화 함수
    func initializeMap() {
        mapController?.prepareEngine()
        mapController?.activateEngine()
    }


    /// 초기 위치 설정 및 뷰 추가 함수
    func addViews() {
        let defaultPosition = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", defaultPosition: defaultPosition)

        mapController?.addView(mapviewInfo)
    }

    // MARK: - MapControllerDelegate Methods
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        print("맵 뷰 추가 성공: \(viewName)")
        backupMapView()
        createLabelLayer()
        createPoiStyle()
    }

    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("맵 뷰 추가 실패: \(viewName)")
    }

    func backupMapView() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        mapView.viewRect = UIScreen.main.bounds
        mapView.eventDelegate = self
    }

    func createLabelLayer() {
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

    func createPoiStyle() {
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

    // MARK: - Authentication Handling
    /// 인증 실패시 호출되는 함수
    /// - Parameters:
    ///   - errorCode: api인증 오류 코드
    ///   - desc: 오류 코드에 대한 설명
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        auth = false
        switch errorCode {
        case 400:
            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
            break;
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
            break;
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
            break;
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
            break;
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")

            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")

                self.mapController?.prepareEngine()
            }
            break;
        default:
            break;
        }
    }

    /// 토스트 표시 함수
    /// - Parameters:
    ///   - view: 토스트 메시지 뷰
    ///   - message: 사용자에게 표시되는 메시지
    ///   - duration: 토스트가 화면에 표시될 시간 ( 2초 )
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width / 2 - 150, y: view.frame.size.height - 100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true

        UIView.animate(withDuration: 0.4,
            delay: duration - 0.4,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: {
                toastLabel.alpha = 0.0
            },
            completion: { (finished) in
                toastLabel.removeFromSuperview()
            })
    }

}
