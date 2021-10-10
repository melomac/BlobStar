import SwiftUI
import os

class AppState: ObservableObject {

    @Published var isActive = true
    private var logger = Logger()
    private var observers = [NSObjectProtocol]()

    init() {
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                self.logger.debug("App will resign active.")
                self.isActive = false
                UIApplication.shared.isIdleTimerDisabled = false
            }
        )
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                self.logger.debug("App did become active.")
                self.isActive = true
                UIApplication.shared.isIdleTimerDisabled = true
            }
        )
    }

    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }
}
