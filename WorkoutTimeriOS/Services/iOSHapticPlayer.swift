import UIKit

struct iOSHapticPlayer: HapticPlayer {
    @MainActor
    func playHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
