//
//  ContentView.swift
//  OCR_Ex
//
//  Created by jaewon Lee on 4/8/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        OCRView()
    }
}

struct CameraPickerView: View {
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("사진을 찍어보세요!")
            }
            
            Button("카메라 열기") {
                showCamera = true
            }
            .padding()
            .sheet(isPresented: $showCamera) {
                CameraPicker { image in
                    self.capturedImage = image
                }
            }
        }
    }
}

struct CameraPickerWithActionSheet: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    
    @State private var showCamera = false
    @State private var showActionSheet = false
    @State private var showPhotosPicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("사진 추가하기") {
                showActionSheet = true
            }
            
            // View로 불러오는 방법인듯?
//            PhotosPicker(
//                "사진 선택하기",
//                selection: $selectedItems,
//                maxSelectionCount: 5,
//                matching: .images
//            )
            ScrollView(.horizontal) {
                HStack {
                    ForEach(images, id:\.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipped()
                    }
                }
            }
        }
        .padding()
        .confirmationDialog(
            "사진을 어떻게 추가할까요?",
            isPresented: $showActionSheet
        ) {
            Button("앨범에서 가져오기") {
                showPhotosPicker = true
            }
            
            Button("카메라로 촬영하기") {
                showCamera = true
            }
            
            Button("취소", role: .cancel) {}
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker { image in
                images.append(image)
            }
        }
        .photosPicker(
            isPresented: $showPhotosPicker,
            selection: $selectedItems,
            maxSelectionCount: 3,
            matching: .images
        )
        .onChange(of: selectedItems) { oldValue, newValue in
            for item in newValue {
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        images.append(image)
                    }
                }
            }
        }
    }

}

#Preview {
    ContentView()
}
