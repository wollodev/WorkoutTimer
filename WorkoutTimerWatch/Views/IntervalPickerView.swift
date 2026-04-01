import SwiftUI

struct IntervalPickerView: View {
    let options: [TimeInterval]
    @Binding var selectedInterval: TimeInterval
    @Binding var isPresented: Bool
    @Binding var breakEnabled: Bool
    @Binding var breakDuration: TimeInterval
    let breakDurationOptions: [TimeInterval]

    var body: some View {
        List {
            Section {
                Toggle(isOn: $breakEnabled) {
                    Text(.breakTime)
                }

                if breakEnabled {
                    NavigationLink {
                        BreakDurationPickerView(
                            options: breakDurationOptions,
                            selectedDuration: $breakDuration
                        )
                    } label: {
                        HStack {
                            Text(.breakDuration)
                            Spacer()
                            Text(DurationFormatter.format(breakDuration))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section {
                ForEach(options, id: \.self) { interval in
                    Button {
                        selectedInterval = interval
                        isPresented = false
                    } label: {
                        HStack {
                            Text(DurationFormatter.format(interval))
                            Spacer()
                            if interval == selectedInterval {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                }
            } header: {
                Text(.interval)
            }
        }
    }
}

struct BreakDurationPickerView: View {
    let options: [TimeInterval]
    @Binding var selectedDuration: TimeInterval
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            ForEach(options, id: \.self) { duration in
                Button {
                    selectedDuration = duration
                    dismiss()
                } label: {
                    HStack {
                        Text(DurationFormatter.format(duration))
                        Spacer()
                        if duration == selectedDuration {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text(.breakDuration))
    }
}
