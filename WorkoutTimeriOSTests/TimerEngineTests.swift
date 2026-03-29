import Foundation
import Testing
@testable import WorkoutTimeriOS

@MainActor
struct TimerEngineTests {
    private func makeEngine() -> TimerEngine {
        TimerEngine()
    }

    @Test("Initial state is correct")
    func initialState() {
        let engine = makeEngine()

        #expect(engine.isRunning == false)
        #expect(engine.remaining == 0)
    }

    @Test("Start sets running state and remaining")
    func startSetsState() {
        let engine = makeEngine()
        engine.selectedInterval = 20

        engine.start()

        #expect(engine.isRunning == true)
        #expect(engine.remaining == 20)
    }

    @Test("Stop resets running state")
    func stopResetsState() {
        let engine = makeEngine()
        engine.start()

        engine.stop()

        #expect(engine.isRunning == false)
    }

    @Test("Tick decrements remaining time")
    func tickDecrements() {
        let engine = makeEngine()
        engine.selectedInterval = 30
        engine.start()

        engine.tick()

        #expect(engine.remaining == 29)
    }

    @Test("Tick resets remaining on reaching zero")
    func tickResetsAtZero() {
        let engine = makeEngine()
        engine.selectedInterval = 3
        engine.start()

        engine.tick() // 2
        engine.tick() // 1
        engine.tick() // 0 → reset to 3

        #expect(engine.remaining == 3)
    }

    @Test("Tick does nothing when not running")
    func tickIgnoredWhenStopped() {
        let engine = makeEngine()
        engine.selectedInterval = 10

        engine.tick()

        #expect(engine.remaining == 0)
    }

    @Test("onTick callback fires with remaining value")
    func onTickCallback() {
        let engine = makeEngine()
        engine.selectedInterval = 5
        var tickValues: [TimeInterval] = []
        engine.onTick = { remaining in tickValues.append(remaining) }

        engine.start()
        engine.tick()
        engine.tick()

        #expect(tickValues == [4, 3])
    }

    @Test("onIntervalComplete fires when reaching zero")
    func onIntervalCompleteCallback() {
        let engine = makeEngine()
        engine.selectedInterval = 2
        var completionCount = 0
        engine.onIntervalComplete = { completionCount += 1 }

        engine.start()
        engine.tick() // 1
        engine.tick() // 0 → complete

        #expect(completionCount == 1)
    }

    @Test("Multiple start/stop cycles work correctly")
    func multipleStartStop() {
        let engine = makeEngine()
        engine.selectedInterval = 15

        engine.start()
        #expect(engine.isRunning == true)
        #expect(engine.remaining == 15)

        engine.stop()
        #expect(engine.isRunning == false)

        engine.selectedInterval = 45
        engine.start()
        #expect(engine.isRunning == true)
        #expect(engine.remaining == 45)

        engine.stop()
        #expect(engine.isRunning == false)
    }

    @Test("Interval options are 5s steps up to 120s")
    func intervalOptions() {
        let engine = makeEngine()

        #expect(engine.intervalOptions.first == 5)
        #expect(engine.intervalOptions.last == 120)
        #expect(engine.intervalOptions.count == 24)
    }

    @Test("Timer continuously cycles after reaching zero")
    func continuousCycling() {
        let engine = makeEngine()
        engine.selectedInterval = 2
        var completionCount = 0
        engine.onIntervalComplete = { completionCount += 1 }

        engine.start()
        // First cycle
        engine.tick() // 1
        engine.tick() // 0 → reset to 2
        // Second cycle
        engine.tick() // 1
        engine.tick() // 0 → reset to 2

        #expect(completionCount == 2)
        #expect(engine.remaining == 2)
    }
}
