import SwiftUI
import AVFoundation

struct FlashBar: View {

    @State var flashMode: Int = 2
    private var settings = Settings.shared

    private var flashModeIcon: String {
        guard
            let mode = AVCaptureDevice.FlashMode.init(rawValue: flashMode),
            let systemIcon = mode.systemIcon
        else {
            return "exclamationmark.triangle.fill"
        }
        return systemIcon
    }

    private var flashModeString: String {
        guard
            let mode = AVCaptureDevice.FlashMode.init(rawValue: flashMode),
            let description = mode.description
        else {
            return "Unknown"
        }
        return description
    }

    var body: some View {
        HStack {
            IconButton(icon: flashModeIcon, action: {
                flashMode += 1
                if flashMode > 2 {
                    flashMode = 0
                }
                settings.flashMode = flashMode
            })
                .accessibilityLabel("Toggle flash")
                .onAppear {
                    DispatchQueue.main.async {
                        flashMode = settings.flashMode
                    }
                }
            Text(flashModeString)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
                .frame(width: 100, alignment: .center)
        }
    }
}
