import SwiftUI

struct IntervalPickerView: View {
    let options: [TimeInterval]
    @Binding var selectedInterval: TimeInterval
    @Environment(\.dismiss) private var dismiss
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        NavigationStack {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(options, id: \.self) { interval in
                    let isSelected = interval == selectedInterval
                    Button {
                        selectedInterval = interval
                    } label: {
                        Text(DurationFormatter.format(interval))
                            .font(.body.weight(isSelected ? .semibold : .regular))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                            .foregroundStyle(isSelected ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .navigationTitle(Text(.interval))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
