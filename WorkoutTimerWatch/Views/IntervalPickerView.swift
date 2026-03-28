import SwiftUI

struct IntervalPickerView: View {

  let options: [Int]
  @Binding var selectedInterval: Int
  @Binding var isPresented: Bool

  var body: some View {
    List {
      ForEach(options, id: \.self) { seconds in
        Button {
          selectedInterval = seconds
          isPresented = false
        } label: {
          HStack {
            Text(DurationFormatter.format(seconds))
            Spacer()
            if seconds == selectedInterval {
              Image(systemName: "checkmark")
                .foregroundStyle(.green)
            }
          }
        }
      }
    }
  }
}
