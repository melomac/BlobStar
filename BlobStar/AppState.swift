import SwiftUI

class AppState: ObservableObject {

    @Published var isActive = true
    private var observers = [NSObjectProtocol]()

    init() {
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                self.isActive = false
                UIApplication.shared.isIdleTimerDisabled = false
            }
        )
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                self.isActive = true
                UIApplication.shared.isIdleTimerDisabled = true
            }
        )
    }

    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }
}
