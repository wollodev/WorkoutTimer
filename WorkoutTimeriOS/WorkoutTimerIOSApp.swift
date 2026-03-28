import SwiftUI

@main
struct WorkoutTimerIOSApp: App {
    @State private var timerManager = iOSTimerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(timerManager)
        }
    }
}
