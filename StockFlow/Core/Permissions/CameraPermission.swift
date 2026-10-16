//
//  CameraPermission.swift
//  StockFlow
//
//  Created by Cicek on 16.10.26.
//

import AVFoundation

enum CameraAccess {
    case granted
    case denied
    case notDetermined
}

enum CameraPermission {
    static var current: CameraAccess {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: return .granted
        case .notDetermined: return .notDetermined
        default: return .denied
        }
    }

    static func request() async -> CameraAccess {
        let allowed = await AVCaptureDevice.requestAccess(for: .video)
        return allowed ? .granted : .denied
    }
}
