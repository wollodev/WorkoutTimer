import WatchKit

protocol HapticPlayer {
  func playHaptic()
}

struct WatchHapticPlayer: HapticPlayer {
  func playHaptic() {
    WKInterfaceDevice.current().play(.success)
  }
}
