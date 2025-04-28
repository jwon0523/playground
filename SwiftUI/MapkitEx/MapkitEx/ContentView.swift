//
//  ContentView.swift
//  MapkitEx
//
//  Created by jaewon Lee on 4/28/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var locationManager = LocationManager.shared
    @State private var viewModel: MapViewModel = .init()
    
    var body: some View {
        Map(position: $viewModel.cameraPosition) {
            ForEach(viewModel.markers, id: \.id) { marker in
                Annotation(marker.title, coordinate: marker.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
