import WatchKit

struct WatchHapticPlayer: HapticPlayer {
    func playHaptic() {
        WKInterfaceDevice.current().play(.success)
    }
}
