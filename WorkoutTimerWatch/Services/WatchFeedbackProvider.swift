import Foundation

@MainActor
final class WatchFeedbackProvider: TimerFeedbackProvider {
    private let hapticPlayer: HapticPlayer

    init(hapticPlayer: HapticPlayer = WatchHapticPlayer()) {
        self.hapticPlayer = hapticPlayer
    }

    func timerStarted() {
        hapticPlayer.playHaptic(.start)
    }

    func timerStopped() {
        hapticPlayer.playHaptic(.stop)
    }

    func intervalStarted() {
        hapticPlayer.playHaptic(.success)
    }

    func intervalCompleted() {
        hapticPlayer.playHaptic(.success)
    }

    func breakStarted() {}

    func breakFinished() {}

    func tick(remaining: TimeInterval, isInBreak: Bool) {}
}
