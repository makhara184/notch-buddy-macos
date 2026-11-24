# NotchBuddy for macOS

![SwiftUI](https://img.shields.io/badge/SwiftUI-macOS%2013%2B-F05138?style=flat-square&logo=swift&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

A playful macOS menu bar reminder app where an animated buddy character **drops down and hangs from the top edge / MacBook notch** with a speech bubble whenever a reminder fires.

## Features

- **Notch Drop-Down Animation**: Spring-physics rope drop and gentle pendulum swing anchored beneath the menu bar/notch.
- **Always-On-Top Non-Activating Overlay**: Uses a transparent `NSPanel` at `.statusBar` level so it appears over full-screen apps without stealing keyboard focus.
- **Selectable Characters**: Switch between Notch Cat, Sleepy Sloth, Mini Bot, and Focus Owl.
- **Quick Menu Bar Presets**: One-click 15m hydration break, 25m stretch break, custom timers, and 5-minute snooze.
- **Interactive Browser Preview**: Open `preview/index.html` in any browser to test the drop-down animation on macOS, Windows, or Linux.

## Project Structure

```text
notch-buddy-macos/
├── Package.swift
├── Sources/NotchBuddy/
│   ├── NotchBuddyApp.swift          # MenuBarExtra entry point & AppDelegate
│   ├── FloatingOverlayWindow.swift  # Transparent NSPanel pinned under the notch
│   ├── HangingCharacterView.swift   # Spring drop + pendulum swing SwiftUI view
│   ├── ReminderStore.swift          # Observable reminder queue & timer engine
│   └── SettingsView.swift           # Character picker & custom reminder form
└── preview/
    └── index.html                   # Interactive browser simulator
```

## Quick Start

### Run on macOS (Swift 5.9+ / Xcode 15+)
```bash
swift run
```

### Preview in Any Browser
Open `preview/index.html` directly in Chrome, Safari, or Edge.

## License
MIT License — see [LICENSE](LICENSE).
