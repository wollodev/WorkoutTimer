import SwiftUI

struct SettingsView: View {
    @Bindable var settings: FeedbackSettings
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(String(localized: "feedback")) {
                    Picker(String(localized: "feedbackType"), selection: $settings.feedbackType) {
                        ForEach(FeedbackType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(String(localized: "countdown")) {
                    Toggle(String(localized: "countdownSound"), isOn: $settings.countdownSoundEnabled)
                    Toggle(String(localized: "spokenCountdown"), isOn: $settings.spokenCountdownEnabled)
                }
            }
            .navigationTitle(String(localized: "settings"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "done")) {
                        dismiss()
                    }
                }
            }
        }
    }
}
