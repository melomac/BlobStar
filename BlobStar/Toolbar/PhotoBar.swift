import SwiftUI
import AVFoundation

struct PhotoBar: View {

    @State private var timeInterval: Double = 42        // minutes
    @State private var timeRemaining: Double = 10 * 60  // seconds
    @EnvironmentObject var state: AppState
    private var settings = Settings.shared

    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common)
        .autoconnect()

    private var timeIntervalString: String {
        String(format: "%.0f min.", timeInterval)
    }

    private func takePhoto() {
        let flashMode = AVCaptureDevice.FlashMode.init(rawValue: settings.flashMode) ?? .auto
        let torchLevel = settings.torchLevel

#if targetEnvironment(simulator)
        let flashModeString = flashMode.description ?? "nil"
        let torchLevelString = String(format: "%.2f", torchLevel)
        print("Take photo with flashMode: \(flashModeString) torchLevel: \(torchLevelString)")
#else
        if torchLevel > 0 {
            torch(mode: .on, level: torchLevel)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                CameraViewController.shared.takePhoto(flash: flashMode) { _, _ in
                    torch(mode: .off)
                }
            }
        } else {
            DispatchQueue.main.async {
                CameraViewController.shared.takePhoto(flash: flashMode)
            }
        }
#endif
    }

    var body: some View {
        HStack {
            IconButton(icon: "camera.fill", action: {
                takePhoto()
            })
                .accessibilityLabel("Capture photo")
            VStack {
                Slider(value: $timeInterval, in: 1...60, step: 1)
                    .accessibilityLabel("Photo timer interval in minutes")
                    .frame(width: 100)
                    .onAppear {
                        DispatchQueue.main.async {
                            timeInterval = settings.timeInterval
                        }
                    }
                    .onChange(of: timeInterval) { minutes in
                        let seconds = minutes * 60
                        if seconds < timeRemaining {
                            timeRemaining = seconds
                        }
                        settings.timeInterval = minutes
                    }
                HStack {
                    Image(systemName: "timer")
                    Text(timeIntervalString)
                        .fontWeight(.bold)
                }
                .foregroundColor(.accentColor)
                .frame(alignment: .center)
            }
        }
        .onReceive(timer) { time in
            guard state.isActive else {
                return
            }
            if timeRemaining > 1 {
                timeRemaining -= 1
                return
            }
            timeRemaining = timeInterval * 60
            takePhoto()
        }
    }
}
