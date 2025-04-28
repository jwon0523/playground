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
}
