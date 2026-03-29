import Foundation
import Testing
@testable import WorkoutTimeriOS

@MainActor
struct TimerEngineTests {
    private func makeEngine() -> TimerEngine {
        UserDefaults.standard.removeObject(forKey: "breakEnabled")
        UserDefaults.standard.removeObject(forKey: "breakDuration")
        UserDefaults.standard.removeObject(forKey: "selectedInterval")
        return TimerEngine()
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

    @Test("Tick shows zero then resets on next tick")
    func tickShowsZeroThenResets() {
        let engine = makeEngine()
        engine.selectedInterval = 3
        engine.start()

        engine.tick() // 2
        engine.tick() // 1
        engine.tick() // 0
        #expect(engine.remaining == 0)

        engine.tick() // reset to 3
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

    @Test("onIntervalComplete fires after zero is shown")
    func onIntervalCompleteCallback() {
        let engine = makeEngine()
        engine.selectedInterval = 2
        var completionCount = 0
        engine.onIntervalComplete = { completionCount += 1 }

        engine.start()
        engine.tick() // 1
        engine.tick() // 0
        #expect(completionCount == 0)

        engine.tick() // complete, reset to 2
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
        engine.tick() // 0
        engine.tick() // complete, reset to 2
        // Second cycle
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // complete, reset to 2

        #expect(completionCount == 2)
        #expect(engine.remaining == 2)
    }

    // MARK: - Break Time Tests

    @Test("Break is disabled by default")
    func breakDisabledByDefault() {
        let engine = makeEngine()

        #expect(engine.breakEnabled == false)
        #expect(engine.isInBreak == false)
    }

    @Test("Break default duration is 10 seconds")
    func breakDefaultDuration() {
        let engine = makeEngine()

        #expect(engine.breakDuration == 10)
    }

    @Test("Break duration options are 1s steps up to 100s")
    func breakDurationOptions() {
        let engine = makeEngine()

        #expect(engine.breakDurationOptions.first == 1)
        #expect(engine.breakDurationOptions.last == 100)
        #expect(engine.breakDurationOptions.count == 100)
    }

    @Test("No break phase when break is disabled")
    func noBreakWhenDisabled() {
        let engine = makeEngine()
        engine.selectedInterval = 2
        engine.breakEnabled = false

        engine.start()
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // complete, reset to 2

        #expect(engine.isInBreak == false)
        #expect(engine.remaining == 2)
    }

    @Test("Enters break phase when break is enabled")
    func entersBreakPhase() {
        let engine = makeEngine()
        engine.selectedInterval = 2
        engine.breakEnabled = true
        engine.breakDuration = 5

        engine.start()
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // complete + break start, remaining = 5

        #expect(engine.isInBreak == true)
        #expect(engine.remaining == 5)
    }

    @Test("onBreakStarted fires when entering break")
    func onBreakStartedCallback() {
        let engine = makeEngine()
        engine.selectedInterval = 2
        engine.breakEnabled = true
        engine.breakDuration = 5
        var breakStartedCount = 0
        engine.onBreakStarted = { breakStartedCount += 1 }

        engine.start()
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // break start

        #expect(breakStartedCount == 1)
    }

    @Test("onBreakFinished fires when break ends")
    func onBreakFinishedCallback() {
        let engine = makeEngine()
        engine.selectedInterval = 3
        engine.breakEnabled = true
        engine.breakDuration = 2
        var breakFinishedCount = 0
        engine.onBreakFinished = { breakFinishedCount += 1 }

        engine.start()
        engine.tick() // 2
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // complete + break start, remaining = 2
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // break finished, remaining = 3

        #expect(breakFinishedCount == 1)
        #expect(engine.isInBreak == false)
        #expect(engine.remaining == 3)
    }

    @Test("Full cycle with break: work → break → work")
    func fullCycleWithBreak() {
        let engine = makeEngine()
        engine.selectedInterval = 2
        engine.breakEnabled = true
        engine.breakDuration = 2
        var completionCount = 0
        var breakStartedCount = 0
        var breakFinishedCount = 0
        engine.onIntervalComplete = { completionCount += 1 }
        engine.onBreakStarted = { breakStartedCount += 1 }
        engine.onBreakFinished = { breakFinishedCount += 1 }

        engine.start()
        // Work phase
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // complete + break start
        #expect(completionCount == 1)
        #expect(breakStartedCount == 1)
        #expect(engine.isInBreak == true)

        // Break phase
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // break finished, remaining = 2
        #expect(breakFinishedCount == 1)
        #expect(engine.isInBreak == false)
        #expect(engine.remaining == 2)

        // Second work phase
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // complete + break start
        #expect(completionCount == 2)
        #expect(breakStartedCount == 2)
    }

    @Test("Stop during break resets break state")
    func stopDuringBreak() {
        let engine = makeEngine()
        engine.selectedInterval = 2
        engine.breakEnabled = true
        engine.breakDuration = 5

        engine.start()
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // break start

        #expect(engine.isInBreak == true)

        engine.stop()

        #expect(engine.isInBreak == false)
        #expect(engine.isRunning == false)
    }

    @Test("Start resets break state")
    func startResetsBreakState() {
        let engine = makeEngine()
        engine.selectedInterval = 2
        engine.breakEnabled = true
        engine.breakDuration = 5

        engine.start()
        engine.tick() // 1
        engine.tick() // 0
        engine.tick() // break start

        engine.start() // restart

        #expect(engine.isInBreak == false)
        #expect(engine.remaining == 2)
    }
}
