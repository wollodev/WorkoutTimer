import Foundation

enum HapticType {
    case success
    case start
    case stop
}

@MainActor
protocol HapticPlayer {
    func playHaptic(_ type: HapticType)
}
