import Foundation

@MainActor
final class iOSFeedbackProvider: TimerFeedbackProvider {
    private let hapticPlayer = iOSHapticPlayer()
    private let audioPlayer = AudioFeedbackPlayer()
    private let countdownPlayer = CountdownSoundPlayer()
    private let spokenPlayer = SpokenCountdownPlayer()

    let feedbackSettings = FeedbackSettings()

    func timerStarted() {
        hapticPlayer.playHaptic(.start)
    }

    func timerStopped() {
        hapticPlayer.playHaptic(.stop)
    }

    func intervalStarted() {
        switch feedbackSettings.feedbackType {
        case .vibration:
            hapticPlayer.playHaptic(.success)
        case .audio:
            audioPlayer.playBeep()
        }
    }

    func intervalCompleted() {
        switch feedbackSettings.feedbackType {
        case .vibration:
            hapticPlayer.playHaptic(.success)
        case .audio:
            audioPlayer.playBeep()
        }
    }

    func breakStarted() {}

    func breakFinished() {}

    func tick(remaining: TimeInterval, isInBreak: Bool) {
        if isInBreak { return }

        let seconds = Int(remaining)

        switch feedbackSettings.countdownType {
        case .off:
            break
        case .sound:
            if seconds >= 1, seconds <= 3 {
                countdownPlayer.playTick()
            } else if seconds <= 0 {
                countdownPlayer.playFinish()
            }
        case .spoken:
            if seconds >= 1, seconds <= 3 {
                spokenPlayer.speakCountdown(seconds)
            } else if seconds <= 0 {
                spokenPlayer.speakDone()
            }
        }
    }
}
