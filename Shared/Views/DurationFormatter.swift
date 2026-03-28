import Foundation

enum DurationFormatter {
    private static let formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.minute, .second]
        f.unitsStyle = .abbreviated
        f.zeroFormattingBehavior = [.dropLeading, .dropTrailing]
        return f
    }()

    static func format(_ interval: TimeInterval) -> String {
        formatter.string(from: interval) ?? "\(Int(interval))s"
    }

    static func formatNumeric(_ interval: TimeInterval) -> String {
        let total = Int(interval)
        let minutes = total / 60
        let seconds = total % 60
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        }
        return "\(seconds)"
    }
}
