import Foundation
import WatchKit

@Observable
@MainActor
final class TimerManager: NSObject, WKExtendedRuntimeSessionDelegate {
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

    private var session: RuntimeSession?
    private let hapticPlayer: HapticPlayer
    private let sessionProvider: RuntimeSessionProvider

    init(
        hapticPlayer: HapticPlayer = WatchHapticPlayer(),
        sessionProvider: RuntimeSessionProvider = WatchRuntimeSessionProvider()
    ) {
        self.hapticPlayer = hapticPlayer
        self.sessionProvider = sessionProvider
        super.init()

        engine.onIntervalComplete = { [weak self] in
            self?.hapticPlayer.playHaptic(.success)
        }

        engine.onBreakFinished = { [weak self] in
            self?.hapticPlayer.playHaptic(.success)
        }
    }

    func start() {
        hapticPlayer.playHaptic(.start)
        session = sessionProvider.makeSession(delegate: self)
        session?.start()
        engine.start()
    }

    func stop() {
        engine.stop()
        session?.invalidate()
        session = nil
        hapticPlayer.playHaptic(.stop)
    }

    // MARK: - WKExtendedRuntimeSessionDelegate

    nonisolated func extendedRuntimeSessionDidStart(
        _: WKExtendedRuntimeSession
    ) {}

    nonisolated func extendedRuntimeSessionWillExpire(
        _: WKExtendedRuntimeSession
    ) {
        MainActor.assumeIsolated {
            stop()
        }
    }

    nonisolated func extendedRuntimeSession(
        _: WKExtendedRuntimeSession,
        didInvalidateWith _: WKExtendedRuntimeSessionInvalidationReason,
        error _: (any Error)?
    ) {
        MainActor.assumeIsolated {
            engine.stop()
        }
    }
}
