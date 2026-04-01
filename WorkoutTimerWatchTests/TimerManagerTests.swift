import Testing
import WatchKit
@testable import WorkoutTimerWatch

final class MockHapticPlayer: HapticPlayer {
    var hapticCount = 0
    var lastType: HapticType?
    func playHaptic(_ type: HapticType) {
        hapticCount += 1
        lastType = type
    }
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
    private func makeManager() -> (TimerManager, MockRuntimeSessionProvider, MockHapticPlayer) {
        UserDefaults.standard.removeObject(forKey: "breakEnabled")
        UserDefaults.standard.removeObject(forKey: "breakDuration")
        UserDefaults.standard.removeObject(forKey: "selectedInterval")
        let sessionProvider = MockRuntimeSessionProvider()
        let hapticPlayer = MockHapticPlayer()
        let manager = TimerManager(
            hapticPlayer: hapticPlayer,
            sessionProvider: sessionProvider
        )
        return (manager, sessionProvider, hapticPlayer)
    }

    @Test("Start creates and starts runtime session")
    func startCreatesSession() {
        let (manager, sessionProvider, _) = makeManager()

        manager.start()

        #expect(sessionProvider.session.started == true)
    }

    @Test("Stop invalidates runtime session")
    func stopInvalidatesSession() {
        let (manager, sessionProvider, _) = makeManager()
        manager.start()

        manager.stop()

        #expect(sessionProvider.session.invalidated == true)
    }

    @Test("Start sets running state via engine")
    func startSetsState() {
        let (manager, _, _) = makeManager()
        manager.selectedInterval = 20

        manager.start()

        #expect(manager.isRunning == true)
        #expect(manager.remaining == 20)
    }

    @Test("Stop resets running state")
    func stopResetsState() {
        let (manager, _, _) = makeManager()
        manager.start()

        manager.stop()

        #expect(manager.isRunning == false)
    }

    @Test("Break state is exposed from engine")
    func breakStateExposed() {
        let (manager, _, _) = makeManager()

        #expect(manager.isInBreak == false)
        #expect(manager.breakEnabled == false)
    }

    @Test("Haptic plays when break finishes")
    func hapticOnBreakFinished() {
        let (manager, _, hapticPlayer) = makeManager()
        manager.selectedInterval = 2
        manager.breakEnabled = true
        manager.breakDuration = 2

        manager.start()
        // Work phase
        manager.engine.tick() // 1
        manager.engine.tick() // 0
        manager.engine.tick() // complete (haptic) + break start (haptic)
        let countAfterBreakStart = hapticPlayer.hapticCount
        // Break phase
        manager.engine.tick() // 1
        manager.engine.tick() // 0
        manager.engine.tick() // break finished (haptic)

        #expect(hapticPlayer.hapticCount == countAfterBreakStart + 1)
    }
}
