//
//  ImageHandling.swift
//  CameraPickerEx
//
//  Created by jaewon Lee on 4/8/25.
//

import UIKit

protocol ImageHandling: AnyObject {
    func addImage(_ image: UIImage)
    func getImages() -> [UIImage]
    var recognizedText: String { get set }
}
