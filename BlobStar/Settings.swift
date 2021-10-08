import Foundation

struct Constants {
    static let flashMode = "flashMode"
    static let timeInterval = "timeInterval"
    static let torchLevel = "torchLevel"
}

class Settings {
    static let shared = Settings()

    var flashMode: Int {
        get {
            UserDefaults.standard.object(forKey: Constants.flashMode) as? Int ?? 2
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.flashMode)
        }
    }

    var timeInterval: Double {
        get {
            UserDefaults.standard.object(forKey: Constants.timeInterval) as? Double ?? 10.0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.timeInterval)
        }
    }

    var torchLevel: Float {
        get {
            UserDefaults.standard.object(forKey: Constants.torchLevel) as? Float ?? 1.0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.torchLevel)
        }
    }
}
