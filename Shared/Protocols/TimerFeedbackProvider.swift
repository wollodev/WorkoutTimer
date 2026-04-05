import Foundation

@MainActor
protocol TimerFeedbackProvider {
    func timerStarted()
    func timerStopped()
    func intervalStarted()
    func intervalCompleted()
    func breakStarted()
    func breakFinished()
    func tick(remaining: TimeInterval, isInBreak: Bool)
}
