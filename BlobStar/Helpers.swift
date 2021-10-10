import AVFoundation
import os

func torch(mode: AVCaptureDevice.TorchMode, level: Float = AVCaptureDevice.maxAvailableTorchLevel) {
    guard
        let device = AVCaptureDevice.default(for: .video),
        device.hasTorch,
        device.isTorchModeSupported(mode)
    else {
        return
    }
    do {
        try device.lockForConfiguration()
        if level <= 0 {
            device.torchMode = .off
        } else if mode == .on {
            try device.setTorchModeOn(level: level)
        } else {
            device.torchMode = mode
        }
        device.unlockForConfiguration()
    } catch {
        Logger().error("Torch error: \(error.localizedDescription) mode: \(mode.rawValue) level: \(level)")
        return
    }
}
