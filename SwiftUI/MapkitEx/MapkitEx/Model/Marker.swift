//
//  Marker.swift
//  MapkitEx
//
//  Created by jaewon Lee on 4/28/25.
//

import Foundation
import MapKit

struct Marker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}
