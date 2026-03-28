import SwiftUI

struct SettingsView: View {
    @Bindable var settings: FeedbackSettings
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
