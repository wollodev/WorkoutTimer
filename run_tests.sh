#!/bin/bash
set -euo pipefail

iOS_DEST='platform=iOS Simulator,name=iPhone 17 Pro'
WATCH_DEST='platform=watchOS Simulator,name=Apple Watch Series 11 (46mm)'

run_tests() {
    local scheme=$1
    local dest=$2
    echo "▶ Testing $scheme"
    xcodebuild test \
        -project WorkoutTimer.xcodeproj \
        -scheme "$scheme" \
        -destination "$dest" \
        -quiet 2>&1 | tail -5
    echo ""
}

case "${1:-all}" in
    ios)   run_tests WorkoutTimeriOS "$iOS_DEST" ;;
    watch) run_tests WorkoutTimerWatch "$WATCH_DEST" ;;
    all)
        run_tests WorkoutTimeriOS "$iOS_DEST"
        run_tests WorkoutTimerWatch "$WATCH_DEST"
        ;;
    *)
        echo "Usage: $0 [ios|watch|all]"
        exit 1
        ;;
esac
