//
//  HybridMapView.swift
//  MapkitEx
//
//  Created by jaewon Lee on 4/29/25.
//

import SwiftUI

struct HybridMapView: View {
    
    @Bindable private var locationManager: LocationManager = .shared
    
    var body: some View {
        ZStack {
            CustomMap(locationManager: locationManager)
                .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    HybridMapView()
}
