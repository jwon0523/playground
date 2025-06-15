//
//  ContentView.swift
//  CarouselEx
//
//  Created by jaewon Lee on 6/15/25.
//

import SwiftUI

struct ContentView: View {
    @State private var activeID: UUID?
    var body: some View {
        NavigationStack {
            VStack {
                CustomCarousel(
                    config: .init(
                        hasOpacity: true,
                        hasScale: true,
                        cardWidth: 250,
                        minimumCardWidth: 30
                    ),
                    selection: $activeID,
                    data: images
                ) { item in
                    Image(item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(height: 120)
            }
            .navigationTitle("Cover Carousel")
        }
    }
}

#Preview {
    ContentView()
}
