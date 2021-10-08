import SwiftUI

struct IconButton: View {

    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Image(systemName: icon)
        })
            .font(.title)
            .frame(width: 64, height: 64)
            .background(Color(UIColor.tertiarySystemBackground))
            .clipShape(Circle())
    }
}
