import UIKit

struct iOSHapticPlayer: HapticPlayer {
    func playHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
