//
//  Image.swift
//  CarouselEx
//
//  Created by jaewon Lee on 6/15/25.
//

import Foundation

struct ImageModel: Identifiable {
    var id: UUID = .init()
    var image: String
}

var images: [ImageModel] = (1...8).compactMap { image in
    ImageModel(image: "Profile \(image)")
}
