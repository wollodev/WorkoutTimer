import SwiftUI

@main
struct WorkoutTimerApp: App {
    @State private var timerManager = TimerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(timerManager)
        }
    }
}
