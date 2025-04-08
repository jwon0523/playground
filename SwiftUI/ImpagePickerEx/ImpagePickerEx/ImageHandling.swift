//
//  ImageHandling.swift
//  ImpagePickerEx
//
//  Created by jaewon Lee on 4/8/25.
//

import Foundation
import SwiftUI

protocol ImageHandling: AnyObject {
    func addImage(_ images: UIImage) // 이미지 추가
    func removeImage(at index: Int) // 이미지 삭제
    func getImages() -> [UIImage] // 추가된 이미지 가져오기
    
    var isImagePickerPresented: Bool { get set } // 앨범 띄우기 참/거짓
    var images: [UIImage] { get set } // 이미지 저장하는 프로퍼티
}
