import SwiftUI

struct Toolbar: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    PhotoBar()
                    FlashBar()
                    TorchBar()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground).opacity(0.90))
                .cornerRadius(12.0)
            }
        }
        .padding()
        .shadow(radius: 5)
    }
}
