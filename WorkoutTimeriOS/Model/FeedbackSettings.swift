import SwiftUI

enum FeedbackType: String, CaseIterable {
    case vibration
    case audio

    var localizedName: LocalizedStringResource {
        switch self {
        case .vibration: .vibration
        case .audio: .audio
        }
    }
}

enum CountdownType: String, CaseIterable {
    case off
    case sound
    case spoken

    var localizedName: LocalizedStringResource {
        switch self {
        case .off: .off
        case .sound: .countdownSound
        case .spoken: .spokenCountdown
        }
    }
}

@Observable
final class FeedbackSettings {
    var feedbackType: FeedbackType {
        didSet { UserDefaults.standard.set(feedbackType.rawValue, forKey: "feedbackType") }
    }

    var countdownType: CountdownType {
        didSet { UserDefaults.standard.set(countdownType.rawValue, forKey: "countdownType") }
    }

    init() {
        feedbackType = FeedbackType(rawValue: UserDefaults.standard.string(forKey: "feedbackType") ?? "vibration") ?? .vibration
        countdownType = CountdownType(rawValue: UserDefaults.standard.string(forKey: "countdownType") ?? "sound") ?? .sound
    }
}
