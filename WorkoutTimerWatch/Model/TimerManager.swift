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
            self?.hapticPlayer.playHaptic()
        }
    }

    func start() {
        session = sessionProvider.makeSession(delegate: self)
        session?.start()
        engine.start()
    }

    func stop() {
        engine.stop()
        session?.invalidate()
        session = nil
    }

    // MARK: - WKExtendedRuntimeSessionDelegate

    func extendedRuntimeSessionDidStart(
        _: WKExtendedRuntimeSession
    ) {}

    func extendedRuntimeSessionWillExpire(
        _: WKExtendedRuntimeSession
    ) {
        hapticPlayer.playHaptic()
        stop()
    }

    func extendedRuntimeSession(
        _: WKExtendedRuntimeSession,
        didInvalidateWith _: WKExtendedRuntimeSessionInvalidationReason,
        error _: (any Error)?
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.engine.stop()
        }
    }
}
