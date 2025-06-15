//
//  CustomCarousel.swift
//  CarouselEx
//
//  Created by jaewon Lee on 6/15/25.
//

import SwiftUI

struct CustomCarousel<
    Content: View,
    Data: RandomAccessCollection
>: View where Data.Element: Identifiable {
    var config: Config
    @Binding var selection: Data.Element.ID?
    var data: Data
    @ViewBuilder var content: (Data.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    Spacer(minLength: (size.width - config.cardWidth) / 2)
                    
                    ForEach(data) { item in
                        ItemView(item)
                    }
                    
                    Spacer(minLength: (size.width - config.cardWidth) / 2)
                }
                .scrollTargetLayout()
            }
//            .safeAreaPadding(.horizontal, max((size.width - config.cardWidth / 2), 0))
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollPosition(id: $selection)
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    func ItemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            let progress = minX / (config.cardWidth + config.spacing)
            let minimumCardWidth = config.minimumCardWidth
            
            let diffWidth = config.cardWidth - minimumCardWidth
            let reducingWidth = progress * diffWidth
            let cappedWidth = min(reducingWidth, diffWidth)
            
            let resizedFrameWidth = size.width - (minX > 0 ? cappedWidth : min(-cappedWidth, diffWidth))
            let negativeProgress = max(-progress, 0)
            
            let scaleValue = config.scaleValue * abs(progress)
            let opacityValue = config.opacityValue * abs(progress)
            
            content(item)
                .frame(width: size.width, height: size.height)
                .frame(width: resizedFrameWidth)
                .opacity(config.hasOpacity ? 1 - opacityValue : 1)
                .scaleEffect(config.hasScale ? 1 - scaleValue : 1)
                .mask {
                    let hasScale = config.hasScale
                    let scaledHeight = (1 - scaleValue) * size.height
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .frame(height: hasScale ? max(scaledHeight, 0) : size.height)
                }
                .clipShape(.rect(cornerRadius: config.cornerRadius))
                .offset(x: -reducingWidth)
                .offset(x: min(progress, 1) * diffWidth)
                .offset(x: negativeProgress * diffWidth)
        }
        .frame(width: config.cardWidth)
//        .background(Color.blue)
    }
    
    // Config
    struct Config {
        var hasOpacity: Bool = false
        var opacityValue: CGFloat = 0.4
        var hasScale: Bool = false
        var scaleValue: CGFloat = 0.2
        
        var cardWidth: CGFloat = 200
        var spacing: CGFloat = 10
        var cornerRadius: CGFloat = 15
        var minimumCardWidth: CGFloat = 40
    }
}

#Preview {
    ContentView()
}
