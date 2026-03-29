import SwiftUI

struct SettingsView: View {
    @Bindable var settings: FeedbackSettings
    @Bindable var timerManager: iOSTimerManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(selection: $settings.feedbackType) {
                        ForEach(FeedbackType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(type)
                        }
                    } label: {
                        Text(.feedbackType)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text(.feedback)
                }

                Section {
                    Picker(selection: $settings.countdownType) {
                        ForEach(CountdownType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(type)
                        }
                    } label: {
                        Text(.countdown)
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                } header: {
                    Text(.countdown)
                }

                Section {
                    Toggle(isOn: $timerManager.breakEnabled) {
                        Text(.breakTime)
                    }

                    if timerManager.breakEnabled {
                        Picker(selection: $timerManager.breakDuration) {
                            ForEach(timerManager.breakDurationOptions, id: \.self) { duration in
                                Text(DurationFormatter.format(duration)).tag(duration)
                            }
                        } label: {
                            Text(.breakDuration)
                        }
                        .pickerStyle(.wheel)
                    }
                } header: {
                    Text(.breakTime)
                }
            }
            .navigationTitle(Text(.settings))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text(.done)
                    }
                }
            }
        }
    }
}
