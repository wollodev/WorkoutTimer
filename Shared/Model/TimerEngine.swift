import Foundation

@Observable
@MainActor
final class TimerEngine {
    let intervalOptions: [TimeInterval] = stride(from: 5, through: 120, by: 5).map {
        TimeInterval($0)
    }

    let breakDurationOptions: [TimeInterval] = stride(from: 1, through: 100, by: 1).map {
        TimeInterval($0)
    }

    var selectedInterval: TimeInterval = {
        let saved = UserDefaults.standard.double(forKey: "selectedInterval")
        return saved > 0 ? saved : 30
    }() {
        didSet {
            UserDefaults.standard.set(selectedInterval, forKey: "selectedInterval")
        }
    }

    var breakEnabled: Bool = UserDefaults.standard.bool(forKey: "breakEnabled") {
        didSet {
            UserDefaults.standard.set(breakEnabled, forKey: "breakEnabled")
        }
    }

    var breakDuration: TimeInterval = {
        let saved = UserDefaults.standard.double(forKey: "breakDuration")
        return saved > 0 ? saved : 10
    }() {
        didSet {
            UserDefaults.standard.set(breakDuration, forKey: "breakDuration")
        }
    }

    var isRunning: Bool = false
    var isInBreak: Bool = false
    var remaining: TimeInterval = 0

    var onTick: ((_ remaining: TimeInterval) -> Void)?
    var onIntervalComplete: (() -> Void)?
    var onBreakStarted: (() -> Void)?
    var onBreakFinished: (() -> Void)?

    private var timer: Timer?

    func start() {
        remaining = selectedInterval
        isRunning = true
        isInBreak = false
        startTimer()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isInBreak = false
    }

    func tick() {
        guard isRunning else { return }

        if remaining <= 0 {
            if isInBreak {
                isInBreak = false
                onBreakFinished?()
                remaining = selectedInterval
            } else {
                onIntervalComplete?()
                if breakEnabled {
                    isInBreak = true
                    onBreakStarted?()
                    remaining = breakDuration
                } else {
                    remaining = selectedInterval
                }
            }
        } else {
            remaining -= 1
        }

        onTick?(remaining)
    }

    private func startTimer() {
        let t = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.tick()
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }
}
