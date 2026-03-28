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
}
