import SwiftUI

struct ContentView: View {

    let appState = AppState()

    var body: some View {
        ZStack {
#if targetEnvironment(simulator)
            Text("CameraView placeholder")
#else
            CameraView()
#endif
            Toolbar()
        }
        .environmentObject(appState)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
