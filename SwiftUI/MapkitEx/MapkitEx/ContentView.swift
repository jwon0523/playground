//
//  ContentView.swift
//  MapkitEx
//
//  Created by jaewon Lee on 4/28/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        // MKCoordinateSpan - 지도에서 가로/세로 방향으로 얼마나 확대해서 보여줄지를 정하는 값. 작을수록 확돼됨.
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        Map(initialPosition: .region(region))
    }
}

#Preview {
    ContentView()
}
