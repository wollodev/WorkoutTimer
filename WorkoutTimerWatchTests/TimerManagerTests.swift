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

@MainActor
struct TimerManagerTests {
    private func makeManager() -> (TimerManager, MockRuntimeSessionProvider) {
        let sessionProvider = MockRuntimeSessionProvider()
        let manager = TimerManager(
            hapticPlayer: MockHapticPlayer(),
            sessionProvider: sessionProvider
        )
        return (manager, sessionProvider)
    }

    @Test("Start creates and starts runtime session")
    func startCreatesSession() {
        let (manager, sessionProvider) = makeManager()

        manager.start()

        #expect(sessionProvider.session.started == true)
    }

    @Test("Stop invalidates runtime session")
    func stopInvalidatesSession() {
        let (manager, sessionProvider) = makeManager()
        manager.start()

        manager.stop()

        #expect(sessionProvider.session.invalidated == true)
    }

    @Test("Start sets running state via engine")
    func startSetsState() {
        let (manager, _) = makeManager()
        manager.selectedInterval = 20

        manager.start()

        #expect(manager.isRunning == true)
        #expect(manager.remaining == 20)
    }

    @Test("Stop resets running state")
    func stopResetsState() {
        let (manager, _) = makeManager()
        manager.start()

        manager.stop()

        #expect(manager.isRunning == false)
    }
}
