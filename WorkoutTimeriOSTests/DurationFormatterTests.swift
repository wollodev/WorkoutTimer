import Testing
@testable import WorkoutTimeriOS

struct DurationFormatterTests {
    // MARK: - formatNumeric

    @Test("Formats seconds under 60 as plain number")
    func numericUnderSixty() {
        #expect(DurationFormatter.formatNumeric(20) == "20")
        #expect(DurationFormatter.formatNumeric(1) == "1")
        #expect(DurationFormatter.formatNumeric(59) == "59")
    }

    @Test("Formats zero as 0")
    func numericZero() {
        #expect(DurationFormatter.formatNumeric(0) == "0")
    }

    @Test("Formats 60 seconds as 1:00")
    func numericExactlyOneMinute() {
        #expect(DurationFormatter.formatNumeric(60) == "1:00")
    }

    @Test("Formats minutes with zero-padded seconds")
    func numericPadding() {
        #expect(DurationFormatter.formatNumeric(65) == "1:05")
        #expect(DurationFormatter.formatNumeric(90) == "1:30")
        #expect(DurationFormatter.formatNumeric(120) == "2:00")
    }

    @Test("Formats over one minute correctly")
    func numericOverOneMinute() {
        #expect(DurationFormatter.formatNumeric(82) == "1:22")
    }

    // MARK: - format (abbreviated)

    @Test("Abbreviated format includes unit labels")
    func abbreviatedFormat() {
        let result = DurationFormatter.format(90)
        #expect(result.contains("1"))
        #expect(result.contains("30"))
    }
}
