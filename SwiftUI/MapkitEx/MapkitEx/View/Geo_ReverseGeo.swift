//
//  Geo_ReverseGeo.swift
//  MapkitEx
//
//  Created by jaewon Lee on 4/29/25.
//

import SwiftUI
import CoreLocation

struct Geo_ReverseGeo: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                let geocoder = CLGeocoder()
                let addressString = "서울특별시 성북구"
                
                do {
                    let placemarks = try await geocoder.geocodeAddressString(addressString)
                    if let location = placemarks.first?.location {
                        print("위도: \(location.coordinate.latitude), 경고: \(location.coordinate.longitude)")
                    }
                } catch {
                    print("지오코딩 에러: \(error.localizedDescription)")
                }
                
                let location = CLLocation(latitude: 37.5665, longitude: 126.9780)
                
                do {
                    let placements = try await geocoder.reverseGeocodeLocation(location)
                    if let placemarks = placements.first {
                        let address = [
                            placemarks.administrativeArea,
                            placemarks.locality,
                            placemarks.subLocality,
                            placemarks.thoroughfare
                        ].compactMap { $0 }.joined(separator: " ")
                        
                        print("주소: \(address)")
                    }
                } catch {
                    print("역지오코딩 에러: \(error.localizedDescription)")
                }
            }
    }
}

#Preview {
    Geo_ReverseGeo()
}
