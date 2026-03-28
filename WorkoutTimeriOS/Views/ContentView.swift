import SwiftUI

struct ContentView: View {
    @Environment(iOSTimerManager.self) private var timerManager
    @State private var showPicker = false
    @State private var showSettings = false

    var body: some View {
        @Bindable var manager = timerManager

        NavigationStack {
            VStack {
                Spacer()

                Button {
                    if !timerManager.isRunning {
                        showPicker = true
                    }
                } label: {
                    let value = timerManager.isRunning ? timerManager.remaining : timerManager.selectedInterval
                    Text(DurationFormatter.formatNumeric(value))
                        .font(.system(size: 120, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(timerManager.isRunning ? .green : .primary)
                }
                .disabled(timerManager.isRunning)

                Spacer()

                Button {
                    if timerManager.isRunning {
                        timerManager.stop()
                    } else {
                        timerManager.start()
                    }
                } label: {
                    Text(timerManager.isRunning ? .stop : .start)
                        .font(.title.weight(.semibold))
                        .padding(.horizontal, 48)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(timerManager.isRunning ? .red : .green)
                .padding(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showPicker) {
                IntervalPickerView(
                    options: timerManager.intervalOptions,
                    selectedInterval: $manager.selectedInterval
                )
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(settings: timerManager.feedbackSettings)
            }
        }
    }
}
