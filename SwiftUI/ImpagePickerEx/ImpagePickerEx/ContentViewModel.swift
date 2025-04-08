//
//  ContentViewModel.swift
//  ImpagePickerEx
//
//  Created by jaewon Lee on 4/8/25.
//

import SwiftUI

@Observable
class ContentViewModel: ImageHandling {
    var isImagePickerPresented: Bool = false
    var images: [UIImage] = []
    
    func addImage(_ images: UIImage) {
        self.images.append(images)
    }
    
    func removeImage(at index: Int) {
        guard !self.images.isEmpty else { return }
        self.images.remove(at: index)
    }
    
    func getImages() -> [UIImage] {
        self.images
    }
}
