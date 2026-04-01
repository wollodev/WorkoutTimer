import UIKit

struct iOSHapticPlayer: HapticPlayer {
    @MainActor
    func playHaptic(_ type: HapticType) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
