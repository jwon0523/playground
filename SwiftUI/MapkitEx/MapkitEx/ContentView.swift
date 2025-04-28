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
    
    @State private var lastKnownLocation: CLLocationCoordinate2D?
    @State private var showSearchButton: Bool = false
    
    @Namespace var mapScope
    
    @State private var showEnteredAlert: Bool = false
    @State private var showExitedAlert: Bool = false
    
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
                
                MapCircle(
                    center: viewModel.geofenceCoordinate,
                    radius: viewModel.geofenceRadius
                )
                .foregroundStyle(.blue.opacity(0.2))
                .stroke(.blue, lineWidth: 2)
            }
            .onChange(of: locationManager.didEnterGeofence) { _, entered in
                if entered {
                    showEnteredAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showEnteredAlert = true
                        locationManager.didEnterGeofence = false
                    }
                }
            }
            .onChange(of: locationManager.didExitGeofence) { _, exited in
                            if exited {
                                showExitedAlert = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showExitedAlert = false
                                    locationManager.didExitGeofence = false
                                }
                            }
                        }
            
            MapUserLocationButton(scope: mapScope)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.clear)
                        .stroke(Color.red, style: .init(lineWidth: 2))
                })
                .offset(x: -10, y: -10)
            
            if showEnteredAlert {
                HStack {
                    Spacer()
                    
                    Text("\(viewModel.geofenceIdentifier) 진입함")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                    
                    Spacer()
                }
            }
            
            if showExitedAlert {
                HStack {
                    Spacer()
                    Text("\(viewModel.geofenceIdentifier) 벗어남")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                    Spacer()
                }
            }
        }
        .mapScope(mapScope)
    }
}

#Preview {
    ContentView()
}

