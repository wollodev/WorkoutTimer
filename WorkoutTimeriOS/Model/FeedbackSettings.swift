import SwiftUI

enum FeedbackType: String, CaseIterable {
    case vibration
    case audio

    var localizedName: String {
        switch self {
        case .vibration: String(localized: "vibration")
        case .audio: String(localized: "audio")
        }
    }
}

@Observable
final class FeedbackSettings {
    var feedbackType: FeedbackType {
        get {
            FeedbackType(rawValue: UserDefaults.standard.string(forKey: "feedbackType") ?? "vibration") ?? .vibration
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "feedbackType")
        }
    }

    var countdownSoundEnabled: Bool {
        get {
            UserDefaults.standard.object(forKey: "countdownSound") as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "countdownSound")
        }
    }
}
