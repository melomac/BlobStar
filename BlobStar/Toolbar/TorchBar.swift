import SwiftUI

struct TorchBar: View {

    @State private var torchLevel: Float = 0.0
    @State private var torchState = false
    private var settings = Settings.shared

    private var torchIcon: String {
        torchState ? "flashlight.on.fill" : "flashlight.off.fill"
    }

    private var torchString: String {
        switch torchLevel {
        case 0.0:
            return "Off"
        case 1.0:
            return "Max"
        default:
            return String(format: "%.0f %%", torchLevel * 100)
        }
    }

    var body: some View {
        HStack {
            IconButton(icon: torchIcon, action: {
                if torchState {
                    torch(mode: .off)
                    torchState = false
                } else {
                    torch(mode: .on, level: torchLevel)
                    torchState = true
                }
            })
                .accessibilityLabel("Toggle torch")
                .disabled(torchLevel == 0)
            VStack {
                Slider(value: $torchLevel, in: 0.0...1.0, step: 0.01)
                    .accessibilityLabel("Torch level in percentages")
                    .frame(width: 100)
                    .onAppear {
                        DispatchQueue.main.async {
                            torchLevel = settings.torchLevel
                        }
                    }
                    .onChange(of: torchLevel) { level in
                        torchState = level > 0 ? true : false
                        torch(mode: level > 0 ? .on : .off, level: level)
                        settings.torchLevel = level
                    }
                Text(torchString)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: 64, alignment: .center)
            }
        }
    }
}
