import Testing
import WatchKit
@testable import WorkoutTimerWatch

struct MockHapticPlayer: HapticPlayer {
    func playHaptic() {}
}

final class MockRuntimeSession: RuntimeSession {
    var started = false
    var invalidated = false

    func start() {
        started = true
    }

    func invalidate() {
        invalidated = true
    }
}

struct MockRuntimeSessionProvider: RuntimeSessionProvider {
    let session = MockRuntimeSession()

    func makeSession(delegate _: any WKExtendedRuntimeSessionDelegate) -> RuntimeSession {
        session
    }
}

struct TimerManagerTests {
    private func makeManager() -> (TimerManager, MockRuntimeSessionProvider) {
        let sessionProvider = MockRuntimeSessionProvider()
        let manager = TimerManager(
            hapticPlayer: MockHapticPlayer(),
            sessionProvider: sessionProvider
        )
        return (manager, sessionProvider)
    }

    @Test("Initial state is correct")
    func initialState() {
        let (manager, _) = makeManager()

        #expect(manager.selectedInterval == 30)
        #expect(manager.isRunning == false)
        #expect(manager.remaining == 0)
        #expect(manager.hapticPlayCount == 0)
    }

    @Test("Start sets running state and countdown")
    func startSetsState() {
        let (manager, _) = makeManager()
        manager.selectedInterval = 20

        manager.start()

        #expect(manager.isRunning == true)
        #expect(manager.remaining == 20)
        #expect(manager.hapticPlayCount == 1)
    }

    @Test("Start creates and starts runtime session")
    func startCreatesSession() {
        let (manager, sessionProvider) = makeManager()

        manager.start()

        #expect(sessionProvider.session.started == true)
    }

    @Test("Stop resets running state")
    func stopResetsState() {
        let (manager, _) = makeManager()
        manager.start()

        manager.stop()

        #expect(manager.isRunning == false)
    }

    @Test("Stop invalidates runtime session")
    func stopInvalidatesSession() {
        let (manager, sessionProvider) = makeManager()
        manager.start()

        manager.stop()

        #expect(sessionProvider.session.invalidated == true)
    }

    @Test("Tick decrements remaining time")
    func tickDecrements() {
        let (manager, _) = makeManager()
        manager.selectedInterval = 30
        manager.start()
        let hapticsBefore = manager.hapticPlayCount

        manager.tick()

        #expect(manager.remaining == 29)
        #expect(manager.hapticPlayCount == hapticsBefore)
    }

    @Test("Tick plays haptic and resets at zero")
    func tickResetsAtZero() {
        let (manager, _) = makeManager()
        manager.selectedInterval = 10
        manager.start()

        for _ in 0 ..< 9 {
            manager.tick()
        }
        #expect(manager.remaining == 1)

        let hapticsBefore = manager.hapticPlayCount
        manager.tick()

        #expect(manager.remaining == 10)
        #expect(manager.hapticPlayCount == hapticsBefore + 1)
    }

    @Test("Tick does nothing when not running")
    func tickIgnoredWhenStopped() {
        let (manager, _) = makeManager()
        manager.selectedInterval = 10

        manager.tick()

        #expect(manager.remaining == 0)
        #expect(manager.hapticPlayCount == 0)
    }

    @Test("Multiple start/stop cycles work correctly")
    func multipleStartStop() {
        let (manager, _) = makeManager()
        manager.selectedInterval = 15

        manager.start()
        #expect(manager.isRunning == true)
        #expect(manager.remaining == 15)

        manager.stop()
        #expect(manager.isRunning == false)

        manager.selectedInterval = 45
        manager.start()
        #expect(manager.isRunning == true)
        #expect(manager.remaining == 45)

        manager.stop()
        #expect(manager.isRunning == false)
    }

    @Test("Full interval cycle plays correct number of haptics")
    func fullIntervalCycle() {
        let (manager, _) = makeManager()
        manager.selectedInterval = 5
        manager.start()

        #expect(manager.hapticPlayCount == 1)

        for _ in 0 ..< 5 {
            manager.tick()
        }

        #expect(manager.hapticPlayCount == 2)
        #expect(manager.remaining == 5)
    }

    @Test("Interval options are 5s steps up to 120s")
    func intervalOptionsExist() {
        let (manager, _) = makeManager()

        #expect(manager.intervalOptions.first == 5)
        #expect(manager.intervalOptions.last == 120)
        #expect(manager.intervalOptions.count == 24)
    }
}
