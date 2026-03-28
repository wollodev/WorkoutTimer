import Foundation

@Observable
@MainActor
final class iOSTimerManager {
    let engine = TimerEngine()

    var intervalOptions: [TimeInterval] {
        engine.intervalOptions
    }

    var selectedInterval: TimeInterval {
        get { engine.selectedInterval }
        set { engine.selectedInterval = newValue }
    }

    var isRunning: Bool {
        engine.isRunning
    }

    var remaining: TimeInterval {
        engine.remaining
    }

    private let hapticPlayer = iOSHapticPlayer()
    private let audioPlayer = AudioFeedbackPlayer()
    private let countdownPlayer = CountdownSoundPlayer()
    private let spokenPlayer = SpokenCountdownPlayer()
    private let backgroundAudio = BackgroundAudioManager()

    var feedbackSettings = FeedbackSettings()

    init() {
        engine.onIntervalComplete = { [weak self] in
            self?.playFeedback()
        }

        engine.onTick = { [weak self] remaining in
            self?.handleTick(remaining: remaining)
        }
    }

    func start() {
        backgroundAudio.activate()
        engine.start()
    }

    func stop() {
        engine.stop()
        backgroundAudio.deactivate()
    }

    private func playFeedback() {
        switch feedbackSettings.feedbackType {
        case .vibration:
            hapticPlayer.playHaptic()
        case .audio:
            if feedbackSettings.countdownType == .off {
                audioPlayer.playBeep()
            }
        }
    }

    private func handleTick(remaining: TimeInterval) {
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
