import SwiftUI

struct AnyPrimitiveButtonStyle: PrimitiveButtonStyle {
  private let makeBodyImpl: (Configuration) -> AnyView

  init<S: PrimitiveButtonStyle>(_ style: S) {
    makeBodyImpl = { configuration in
      AnyView(style.makeBody(configuration: configuration))
    }
  }

  func makeBody(configuration: Configuration) -> some View {
    makeBodyImpl(configuration)
  }
}

struct ContentView: View {

  @Environment(TimerManager.self) private var timerManager
  @State private var showPicker = false

  var body: some View {
    @Bindable var manager = timerManager

    VStack {
      Button {
        if !timerManager.isRunning {
          showPicker = true
        }
      } label: {
        Text(
          DurationFormatter.format(
            timerManager.isRunning ? timerManager.secondsRemaining : timerManager.selectedInterval)
        )
        .font(.system(size: 64, weight: .bold, design: .rounded))
        .monospacedDigit()
        .foregroundStyle(timerManager.isRunning ? .green : .primary)
      }
      .buttonStyle(.bordered)
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
          .frame(maxWidth: .infinity)
      }
      .tint(timerManager.isRunning ? .red : .green)
    }
    .ignoresSafeArea(edges: .bottom)
    .padding()
    .sheet(isPresented: $showPicker) {
      IntervalPickerView(
        options: timerManager.intervalOptions,
        selectedInterval: $manager.selectedInterval,
        isPresented: $showPicker
      )
    }
  }
}
