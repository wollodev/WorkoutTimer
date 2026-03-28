import Foundation

@Observable
final class TimerEngine {
    let intervalOptions: [TimeInterval] = stride(from: 5, through: 120, by: 5).map {
        TimeInterval($0)
    }

    var selectedInterval: TimeInterval = 30
    var isRunning: Bool = false
    var remaining: TimeInterval = 0

    var onTick: ((_ remaining: TimeInterval) -> Void)?
    var onIntervalComplete: (() -> Void)?

    private var timer: Timer?

    func start() {
        remaining = selectedInterval
        isRunning = true
        startTimer()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func tick() {
        guard isRunning else { return }

        if remaining <= 0 {
            remaining = selectedInterval
            return
        }

        remaining -= 1
        onTick?(remaining)

        if remaining <= 0 {
            onIntervalComplete?()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
}
