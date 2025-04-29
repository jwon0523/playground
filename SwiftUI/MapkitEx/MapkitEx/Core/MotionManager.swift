//
//  MotionManager.swift
//  MapkitEx
//
//  Created by jaewon Lee on 4/28/25.
//

import CoreMotion
import SwiftUI

/// MotionManager 클래스는 휴대폰의 방향(Yaw 값)을 실시간으로 가져와서 개인 마커 회전 등에 활용하기 위한 매니저이다.
/// CMMotionManager를 이용해 deviceMotion(가속도, 자이로 융합 데이터)를 받아온다.
/// 아직 이해가 부족해서 나중에 공부 더 해야할듯..
@Observable
final class MotionManager: ObservableObject {
    
    static let shared = MotionManager()
    
    private let motionManager = CMMotionManager()
    
    /// 모션 업데이트 주기 (초당 약 30회 업데이트)
    private let updateInterval = 1.0 / 30.0

    /// 휴대폰의 Yaw(수평 회전) 각도를 저장하는 변수
    /// SwiftUI View와 연결하여 개인 마커 회전에 사용
    var heading: Double = 0.0
    
    /// 마지막으로 기록된 Yaw 값을 저장하는 변수
    /// 새로운 Yaw와 부드럽게 연결(Smoothing)하는 데 사용
    private var lastYaw: Double = 0.0

    init() {
        startUpdates()
    }

    /// 새로운 Yaw 값을 받아서 이전 값과 보간하여 부드럽게 만든다.
    /// - Parameters new: 새로 측정된 Yaw 값
    /// - Returns: 보정된(스무딩된) Yaw 값
    private func smoothYaw(_ new: Double) -> Double {
        /// Low-pass filter를 적용해 Yaw 값을 부드럽게 갱신
        /// - Low-pass filter(LPF)는 빠른 변화(고주파 성분)은 줄이고, 느린 변화(저주파 성분)은 통과시키는 필터이다.
        /// - 즉, 갑작스러운 큰 변화 억제하고, 천천히 변하는 데이터만 따라가게 하는 것이다.
        /// - 왜 필요한가 하면, IMU 센서 데이터는 미세하게 덜덜거리는 노이즈값이나 튀는 값이 존재하기 때문이다.
        /// - 이걸 바로 화면에 반영하면 마커가 불안정하게 회전하거나 갑자기 방향이 튀는 현상 발생한다.
        /// - 이전 Yaw 값과 새로 측정한 Yaw 값을 섞어 자연스러운 변화를 만든다.
        /// - alpha가 작을수록 변화가 느리고 부드럽고, 클수록 빠르게 반영
        let alpha = 0.15
        lastYaw = (1 - alpha) * lastYaw + alpha * new
        return lastYaw
    }

    /// 디바이스 모션 업데이트를 시작.
    /// 주기적으로 Yaw 값을 측정하고, 부드럽게 보정한 뒤, SwiftUI View에 반영한다.
    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let motion = motion else { return }

            let yaw = motion.attitude.yaw
            let smoothed = self?.smoothYaw(yaw) ?? yaw

            DispatchQueue.main.async {
                withAnimation(.linear(duration: 0.1)) {
                    self?.heading = smoothed
                }
            }
        }
    }
}
