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
        Map(position: $viewModel.cameraPosition)
    }
}

#Preview {
    ContentView()
}
