import Foundation
import UIKit

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

    var isInBreak: Bool {
        engine.isInBreak
    }

    var breakEnabled: Bool {
        get { engine.breakEnabled }
        set { engine.breakEnabled = newValue }
    }

    var breakDuration: TimeInterval {
        get { engine.breakDuration }
        set { engine.breakDuration = newValue }
    }

    var breakDurationOptions: [TimeInterval] {
        engine.breakDurationOptions
    }

    let feedbackProvider = iOSFeedbackProvider()
    private let backgroundAudio = BackgroundAudioManager()

    var feedbackSettings: FeedbackSettings {
        feedbackProvider.feedbackSettings
    }

    init() {
        engine.onIntervalStarted = { [weak self] in
            self?.feedbackProvider.intervalStarted()
        }

        engine.onIntervalComplete = { [weak self] in
            self?.feedbackProvider.intervalCompleted()
        }

        engine.onTick = { [weak self] remaining in
            guard let self else { return }
            self.feedbackProvider.tick(remaining: remaining, isInBreak: self.engine.isInBreak)
        }

        engine.onBreakStarted = { [weak self] in
            self?.feedbackProvider.breakStarted()
        }

        engine.onBreakFinished = { [weak self] in
            self?.feedbackProvider.breakFinished()
        }
    }

    func start() {
        UIApplication.shared.isIdleTimerDisabled = true
        feedbackProvider.timerStarted()
        backgroundAudio.activate()
        engine.start()
    }

    func stop() {
        engine.stop()
        backgroundAudio.deactivate()
        feedbackProvider.timerStopped()
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
