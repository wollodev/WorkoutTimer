import AVFoundation
import SwiftUI

@main
struct WorkoutTimerIOSApp: App {
    @State private var timerManager: iOSTimerManager

    init() {
        // Configure audio session before creating any players
        // .mixWithOthers ensures we don't interrupt music
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, options: .mixWithOthers)
        try? session.setActive(true)

        _timerManager = State(initialValue: iOSTimerManager())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(timerManager)
        }
    }
}
