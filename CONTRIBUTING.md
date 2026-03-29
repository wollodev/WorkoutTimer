# Contributing to WorkoutTimer

Thanks for your interest in contributing! Here's how to get started.

## How to Contribute

1. **Fork** the repository
2. **Create a branch** from `master` for your change
3. **Make your changes** and ensure tests pass
4. **Open a pull request** with a clear description of what you changed and why

## Code Style

- **Swift 6** with strict concurrency enabled
- **SwiftUI** for all views
- Use `@Observable` and `@MainActor` where appropriate
- Keep shared logic in `Shared/` — platform-specific code goes in `WorkoutTimerWatch/` or `WorkoutTimeriOS/`
- Follow existing patterns (e.g., protocol-based dependency injection for testability)

## Testing

Please add or update tests for any changes:

```bash
# Run iOS tests
xcodebuild test -scheme WorkoutTimeriOS -destination 'platform=iOS Simulator,name=iPhone 17'

# Run watchOS tests
xcodebuild test -scheme WorkoutTimerWatch -destination 'platform=watchOS Simulator,name=Apple Watch Series 11 (46mm)'
```

- Shared logic tests (TimerEngine, DurationFormatter) live in `WorkoutTimeriOSTests/`
- Watch-specific tests (TimerManager, sessions) live in `WorkoutTimerWatchTests/`
- Use Swift Testing framework (`import Testing`), not XCTest

## Reporting Issues

Open an issue on GitHub with:
- What you expected to happen
- What actually happened
- Steps to reproduce
