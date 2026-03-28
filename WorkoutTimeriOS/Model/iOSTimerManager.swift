import Foundation

@Observable
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
            if !feedbackSettings.countdownSoundEnabled {
                audioPlayer.playBeep()
            }
        }
    }

    private func handleTick(remaining: TimeInterval) {
        guard feedbackSettings.countdownSoundEnabled else { return }

        let seconds = Int(remaining)
        if seconds >= 1, seconds <= 3 {
            countdownPlayer.playTick()
        } else if seconds <= 0 {
            countdownPlayer.playFinish()
        }
    }
}
