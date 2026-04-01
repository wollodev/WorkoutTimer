import WatchKit

struct WatchHapticPlayer: HapticPlayer {
    func playHaptic(_ type: HapticType) {
        let wkType: WKHapticType = switch type {
        case .success: .success
        case .start: .start
        case .stop: .stop
        }
        WKInterfaceDevice.current().play(wkType)
    }
}
