import SwiftUI

struct IntervalPickerView: View {
    let options: [TimeInterval]
    @Binding var selectedInterval: TimeInterval
    @Binding var isPresented: Bool

    var body: some View {
        List {
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
        }
    }
}
