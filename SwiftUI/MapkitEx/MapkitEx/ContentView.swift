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
    @Namespace var mapScope
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(position: $viewModel.cameraPosition, scope: mapScope) {
                ForEach(viewModel.makers, id: \.id, content: { marker in
                    Annotation(marker.title, coordinate: marker.coordinate, content: {
                        Image(systemName: "mappin.circle.fill")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.red)
                    })
                })
                
                UserAnnotation()
            }
            
            MapUserLocationButton(scope: mapScope)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.clear)
                        .stroke(Color.red, style: .init(lineWidth: 2))
                })
                .offset(x: -10, y: -10)
        }
        .mapScope(mapScope)
    }
}

#Preview {
    ContentView()
}

