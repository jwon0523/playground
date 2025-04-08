//
//  ContentView.swift
//  ImpagePickerEx
//
//  Created by jaewon Lee on 4/8/25.
//

import SwiftUI

struct ContentView: View {
    @Bindable var viewModel: ContentViewModel = .init()
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(
                        viewModel.getImages(),
                        id: \.self
                    ) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
            }
            
            Button("앨범에서 사진 선택") {
                viewModel.isImagePickerPresented.toggle()
            }
        }
        .sheet(
            isPresented: $viewModel.isImagePickerPresented
        ) {
            ImagePicker(
                imageHandler: viewModel,
                selectedLimit: 5
            )
        }
    }
}

#Preview {
    ContentView()
}
