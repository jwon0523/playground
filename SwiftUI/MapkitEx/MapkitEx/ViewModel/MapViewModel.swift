//
//  MapViewModel.swift
//  MapkitEx
//
//  Created by jaewon Lee on 4/28/25.
//

import SwiftUI
import MapKit

@Observable
final class MapViewModel {
    var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    var currentMapCenter: CLLocationCoordinate2D?
    
    var searchResults: [Place] = []
    
    /// `MKCoordinateRegion`: 지도에서 보여줄 여역(중심 좌표 + 줌 정도), 카메로 위치 설정에 사용
    var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.583123, longitude: 127.010695),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var makers: [Marker] = [
        .init(
            coordinate: .init(latitude: 37.583123, longitude: 127.010695),
            title: "한성대학교"
        ),
        .init(
            coordinate: .init(latitude: 37.580689, longitude: 127.002827),
            title: "마로니에 공원"
        )
    ]
    
    let geofenceCoordinate = CLLocationCoordinate2D(latitude: 37.583123, longitude: 127.010695)
    let geofenceRadius: CLLocationDistance = 100
    let geofenceIdentifier = "한성대"
    
    init() {
//        LocationManager.shared.startMonitoringGeofence(
//            center: geofenceCoordinate,
//            radius: geofenceRadius,
//            identifier: geofenceIdentifier
//        )
        LocationManager.shared.startMonitoringGeofenceWithCLMonitor(
            center: geofenceCoordinate,
            radius: geofenceRadius,
            identifier: geofenceIdentifier
        )
    }
    
    func search(query: String, to location: CLLocation) {
        // MKLocalSearch - 실제로 검색을 실행하는 객체
        // 어떤 키워드로, 어떤 위치 기준으로 검색할지 설정
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = .init(
            center: location.coordinate,
            span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        let search = MKLocalSearch(request: request)
        // 비동기로 검색을 실행, 결과를 클로저로 반환
        search.start { [weak self] response, error in
            guard let self, let mapItems = response?.mapItems else { return }
            
            DispatchQueue.main.async {
                self.searchResults = mapItems.map { Place(mapItem: $0) }
            }
        }
    }
}
