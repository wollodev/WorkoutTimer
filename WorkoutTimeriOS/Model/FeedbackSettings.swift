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

enum CountdownType: String, CaseIterable {
    case off
    case sound
    case spoken

    var localizedName: String {
        switch self {
        case .off: String(localized: "off")
        case .sound: String(localized: "countdownSound")
        case .spoken: String(localized: "spokenCountdown")
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

    var countdownType: CountdownType {
        get {
            CountdownType(rawValue: UserDefaults.standard.string(forKey: "countdownType") ?? "sound") ?? .sound
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "countdownType")
        }
    }
}
