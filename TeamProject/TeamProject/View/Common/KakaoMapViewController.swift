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
        NotificationCenter.default.removeObserver(self, name: Notification.Name("rentStatusChanged"), object: nil)
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
            zOrder: 100
        )
        _ = manager.addLabelLayer(option: layerOption)

        // ── 현재 위치 POI 레이어 ──
        let locOption = LabelLayerOptions(
            layerID: "CurrentLocationLayer",
            competitionType: .none,
            competitionUnit: .symbolFirst,
            orderType: .rank,
            zOrder: 200
        )
        _ = manager.addLabelLayer(option: locOption)
    }

    func createPoiStyle() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()

        ["A", "B", "C"].forEach { type in
            
            guard let originalImage = UIImage(named: "kickboard_\(type)") else {
                print("kickboard_\(type) 이미지 로드 실패")
                return
            }

            let targetSize = CGSize(width: 30, height: 30)
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            let resizedImage = renderer.image { _ in
                originalImage.draw(in: CGRect(origin: .zero, size: targetSize))
            }

            let iconStyle = PoiIconStyle(
                symbol: resizedImage,
                anchorPoint: CGPoint(x: 0.5, y: 1.0)
            )

            let poiStyle = PoiStyle(styleID: "kickboardMarkStyleID_\(type)", styles: [
                PerLevelPoiStyle(iconStyle: iconStyle, level: 5)
                ])

            manager.addPoiStyle(poiStyle)
        }

        guard let locImage = UIImage(named: "marker") else {
            print("marker 이미지 로드 실패")
            return
        }

        let targetSize = CGSize(width: 20, height: 20)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            locImage.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        let iconStyle = PoiIconStyle(
            symbol: resizedImage,
            anchorPoint: CGPoint(x: 0.5, y: 1.0)
        )
        let poiStyle = PoiStyle(styleID: "currentLocationStyle", styles: [PerLevelPoiStyle(iconStyle: iconStyle, level: 15)])
        manager.addPoiStyle(poiStyle)

    }

//    // MARK: - Authentication Handling
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
            print("지도 종료(API인증 파라미터 오류)")
            break;
        case 401:
            print("지도 종료(API인증 키 오류)")
            break;
        case 403:
            print("지도 종료(API인증 권한 오류)")
            break;
        case 429:
            print("지도 종료(API 사용쿼터 초과)")
            break;
        case 499:
            print("지도 종료(네트워크 오류) 5초 후 재시도..")
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

}
