import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
#if targetEnvironment(simulator)
            Text("CameraView placeholder")
#else
            CameraView()
#endif
            Toolbar()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text("CameraView placeholder")
            Toolbar()
        }
    }
}
