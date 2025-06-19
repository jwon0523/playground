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
    // 각 항목에 대한 뷰 생성 클로저
    @ViewBuilder var content: (Data.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size // 부모 뷰의 사이즈를 가져옴
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    // 좌측에 Spacer를 넣어 캐러셀을 가운데 정렬
                    Spacer(minLength: (size.width - config.cardWidth) / 2)
                    
                    // 각 데이터 항목에 대해 ItemView로 구성
                    ForEach(data) { item in
                        ItemView(item)
                    }
                    
                    // 우측에도 Spacer 추가로 대칭 정렬 유지
                    Spacer(minLength: (size.width - config.cardWidth) / 2)
                }
                .scrollTargetLayout() // 스크롤 대상 항목의 레이아웃 적용
            }
            // 각 항목을 스크롤 위치에 정렬
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollPosition(id: $selection) // 선택된 항목 ID에 따라 위치 조정
            .scrollIndicators(.hidden)
        }
    }
    
    // 하나의 데이터 항목에 대한 캐러셀 카드 뷰
    @ViewBuilder
    func ItemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            // 스크롤 뷰 내에서의 현재 카드 위치 (minX: 가장 왼쪽 x 좌표)
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            
            // 현재 항목이 얼마나 오른쪽으로 이동했는지 비율로 계산
            let progress = minX / (config.cardWidth + config.spacing)
            let minimumCardWidth = config.minimumCardWidth
            
            // 최소 카드 너비와 현재 카드 너비 간 차이 계산
            let diffWidth = config.cardWidth - minimumCardWidth
            
            // 카드의 위치(progress)에 따라 줄어들 너비 계산
            let reducingWidth = progress * diffWidth
            
            // 최대 줄어들 수 있는 너비 이상으로 줄어들지 않도록 제한
            let cappedWidth = min(reducingWidth, diffWidth)
            
            // 최종 카드의 width 계산 (좌우 이동 위치에 따라 너비 축소)
            let resizedFrameWidth = size.width - (minX > 0 ? cappedWidth : min(-cappedWidth, diffWidth))
            
            // 왼쪽으로 이동한 경우에만 적용되는 음수 progress
            let negativeProgress = max(-progress, 0)
            
            // 축소 비율 및 투명도 비율 계산
            let scaleValue = config.scaleValue * abs(progress)
            let opacityValue = config.opacityValue * abs(progress)
            
            // 유저가 전달한 content 클로저로 실제 카드 콘텐츠 구성
            content(item)
                .frame(width: size.width, height: size.height) // 원래 크기
                .frame(width: resizedFrameWidth) // 축소 적용
                .opacity(config.hasOpacity ? 1 - opacityValue : 1) // 투명도 적용 여부
                .scaleEffect(config.hasScale ? 1 - scaleValue : 1) // 스케일 적용 여부
                .mask {
                    // 마스크로 코너 radius 유지 + 축소 시 높이도 조정
                    let hasScale = config.hasScale
                    let scaledHeight = (1 - scaleValue) * size.height
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .frame(height: hasScale ? max(scaledHeight, 0) : size.height)
                }
                .clipShape(.rect(cornerRadius: config.cornerRadius)) // 라운드 적용
                .offset(x: -reducingWidth) // 줄어든 width만큼 왼쪽으로 보정
                .offset(x: min(progress, 1) * diffWidth) // 오른쪽 이동 시 위치 보정
                .offset(x: negativeProgress * diffWidth) // 왼쪽 이동 시 위치 보정
        }
        .frame(width: config.cardWidth) // 기본 카드 너비
//        .background(Color.blue) // 디버깅용 배경
    }
    
    // 캐러셀 구성 설정 구조체
    struct Config {
        var hasOpacity: Bool = false // 투명도 효과 활성화 여부
        var opacityValue: CGFloat = 0.4 // 투명도 적용 비율
        var hasScale: Bool = false // 스케일 효과 활성화 여부
        var scaleValue: CGFloat = 0.2 // 스케일 적용 비율
        
        var cardWidth: CGFloat = 200 // 기본 카드 너비
        var spacing: CGFloat = 10 // 카드 간 간격
        var cornerRadius: CGFloat = 15 // 카드의 모서리 반지름
        var minimumCardWidth: CGFloat = 40 // 최소 카드 너비
    }
}

#Preview {
    ContentView()
}
