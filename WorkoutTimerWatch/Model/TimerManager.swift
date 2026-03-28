import Foundation
import WatchKit

@Observable
final class TimerManager: NSObject, WKExtendedRuntimeSessionDelegate {
    let intervalOptions: [TimeInterval] = stride(from: 5, through: 120, by: 5).map {
        TimeInterval($0)
    }

    var selectedInterval: TimeInterval = 30
    var isRunning: Bool = false
    var remaining: TimeInterval = 0

    private(set) var hapticPlayCount: Int = 0

    private var timer: Timer?
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
    }

    func start() {
        remaining = selectedInterval
        isRunning = true

        session = sessionProvider.makeSession(delegate: self)
        session?.start()

        hapticPlayCount = 0
        playHaptic()
        startTimer()
    }

    func stop() {
        timer?.invalidate()
        timer = nil

        session?.invalidate()
        session = nil

        isRunning = false
    }

    func tick() {
        guard isRunning else { return }
        remaining -= 1

        if remaining <= 0 {
            playHaptic()
            remaining = selectedInterval
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func playHaptic() {
        hapticPlayCount += 1
        hapticPlayer.playHaptic()
    }

    // MARK: - WKExtendedRuntimeSessionDelegate

    func extendedRuntimeSessionDidStart(
        _: WKExtendedRuntimeSession
    ) {}

    func extendedRuntimeSessionWillExpire(
        _: WKExtendedRuntimeSession
    ) {
        playHaptic()
        stop()
    }

    func extendedRuntimeSession(
        _: WKExtendedRuntimeSession,
        didInvalidateWith _: WKExtendedRuntimeSessionInvalidationReason,
        error _: (any Error)?
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.isRunning = false
        }
    }
}
