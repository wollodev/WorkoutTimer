import Foundation

@Observable
@MainActor
final class TimerEngine {
    let intervalOptions: [TimeInterval] = stride(from: 5, through: 120, by: 5).map {
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

        remaining -= 1
        onTick?(remaining)

        if remaining <= 0 {
            onIntervalComplete?()
            remaining = selectedInterval
        }
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
