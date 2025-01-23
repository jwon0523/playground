//
//  MapViewController.swift
//  KakaoMapExample
//
//  Created by jaewon Lee on 1/18/25.
//

import UIKit
import NMapsMap

class MapViewController: UIViewController, CLLocationManagerDelegate,NMFMapViewTouchDelegate {
    private var mapView: NMFMapView!
    //    private var naverMapView: NMFNaverMapView!
    private var locationManager: CLLocationManager!
    private var locationOveralay: NMFLocationOverlay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        addMarker()
        setupLocationManager()
    }
    
    // MARK: - 지도 뷰 띄우기
    
    private func setupMapView() {
        mapView = NMFMapView(frame: self.view.bounds)
        self.view.addSubview(mapView)
        
        // 실내 지도 활성화
        mapView.isIndoorMapEnabled = true
        
        //        let cameraPosition = NMFCameraPosition()
        let cameraPosition = mapView.cameraPosition
        print(cameraPosition)
        
        // 네이버 지도 SDK는 UIGestureRecognizer를 상속 받은 형태. 다향한 제스처 정의 가능
        mapView.touchDelegate = self
        
        // LocationOveraly 활성화
        locationOveralay = mapView.locationOverlay
        locationOveralay.hidden = false
        
        mapView.positionMode = .compass
        
    }
    
    // MARK: - 마커 생성
    
    private func addMarker() {
        // 마커 위치 설정
        let markerPosition = NMGLatLng(lat: 37.5665, lng: 126.9780) // 서울시청 좌표
        
        // 마커 생성
        let marker = NMFMarker(position: markerPosition)
        marker.captionText = "서울시청" // 마커 캡션
        marker.iconImage = NMFOverlayImage(name: "markerIcon") // 커스텀 아이콘 (선택)
        marker.width = 30 // 크기 (선택)
        marker.height = 40 // 크기 (선택)
        
        // 마커 지도에 추가
        marker.mapView = mapView
    }
    
    // MARK: - 위치 처리
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // 현재 위치를 지속적으로 추적
    }
    
    // 위치 업데이트 처리
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let currentLat = location.coordinate.latitude
        let currentLng = location.coordinate.longitude
        print(currentLat)
//        let currentLocation = NMGLatLng(
//            lat: currentLat,
//            lng: currentLng
//        )
        
//        /// Reverse Geocoding으로 좌표를 주소로 바꿔줌
//        ReverseGeocodingManage.shared.fetchAddress(
//            latitude: location.coordinate.latitude,
//            longitude: location.coordinate.longitude
//        ) { addressInfo in
//            if let info = addressInfo {
//                print("법정동: \(info.lawDistrict)")
//                print("행정동: \(info.adminDistrict)")
//                print("지번 주소: \(info.landAddress ?? "없음")")
//                print("도로명 주소: \(info.roadAddress ?? "없음")")
//            } else {
//                print("주소 정보를 가져올 수 없습니다.")
//            }
//        }
        
//        /// 지역 기반 검색
//        let query = "스타벅스" // 검색 키워드
//
//        PlaceSearchManager.shared.fetchLocalPlaces(query: query) { places in
//            if let places = places {
//                for place in places {
//                    print("장소명: \(place.name)")
//                    print("카테고리: \(place.category)")
//                    print("주소: \(place.address)")
//                    print("도로명 주소: \(place.roadAddress)")
//                    print("----------------------")
//                }
//            } else {
//                print("장소 정보를 가져올 수 없습니다.")
//            }
//        }
        
        /// 지도 중심 이동
        /// - locationOverlay를 수동으로 업데이트 하면, positionMode와 충돌 발생할 수 있으므로 주석 처리
        //        let cameraUpdate = NMFCameraUpdate(scrollTo: currentLocation)
        //        mapView.moveCamera(cameraUpdate)
        
        /// 위와 같은 문제로 positionMode와 충돌하기에 주석 처리
        //        locationOveralay.location = currentLocation // 현재 위치 표시
        //        print("현재 나의 위치: \(currentLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("위치 정보 업데이트 실패: \(error.localizedDescription)")
    }
    
    /// 탭 제스처
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("탭: \(latlng.lat), \(latlng.lng)")
    }
    
    // 롱 탭 제스처
    func mapView(_ mapView: NMFMapView, didLongTapMap latlng: NMGLatLng, point: CGPoint) {
        print("롱 탭: \(latlng.lat), \(latlng.lng)")
    }
    
    /// 심벌 탭 이벤트
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        if symbol.caption == "서울특별시청" {
            print("서울시청 탭")
            return true
            
        } else {
            print("symbol 탭")
            return false
        }
    }
    
    // MARK: - 지도 방향 변경하기
    
    //    private func updateMapDirection(to coordinate: NMGLatLng, heading: Double, tilt: Double) {
    //        // 카메라 업데이트 매개변수 생성
    //        let cameraUpdateParams = NMFCameraUpdateParams()
    //        cameraUpdateParams.scroll(to: coordinate) // 지도 중심 이동
    //        cameraUpdateParams.rotate(to: heading)   // 지도 방향 설정 (북쪽 기준 각도)
    //        cameraUpdateParams.tilt(to: tilt)        // 지도 기울기 설정 (0~60도)
    //
    //        // 카메라 업데이트 적용
    //        mapView.moveCamera(NMFCameraUpdate(params: cameraUpdateParams))
    //    }
}
