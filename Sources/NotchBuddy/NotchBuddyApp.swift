import SwiftUI
import AppKit

@main
struct NotchBuddyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var store = ReminderStore.shared

    var body: some Scene {
        MenuBarExtra("NotchBuddy", systemImage: "bell.badge.fill") {
            VStack(alignment: .leading, spacing: 8) {
                Text("NotchBuddy Reminders")
                    .font(.headline)

                Divider()

                Button("Trigger Hang-Down Preview") {
                    store.triggerDemoReminder()
                }
                .keyboardShortcut("t")

                Button("Add Quick 15m Water Break") {
                    store.addQuickReminder(title: "Drink some water!", minutes: 15, emoji: "💧")
                }

                Button("Add Quick 25m Stretch Break") {
                    store.addQuickReminder(title: "Stand up & stretch!", minutes: 25, emoji: "🧘")
                }

                Divider()

                if store.reminders.isEmpty {
                    Text("No active reminders")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                } else {
                    ForEach(store.reminders.prefix(4)) { item in
                        HStack {
                            Text("\(item.emoji) \(item.title)")
                                .lineLimit(1)
                            Spacer()
                            Text(item.dueDate, style: .time)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Divider()

                SettingsLink {
                    Text("Manage Reminders...")
                }

                Button("Quit NotchBuddy") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
            .padding(8)
            .frame(width: 260)
        }

        Settings {
            SettingsView()
                .environmentObject(store)
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var overlayController: FloatingOverlayController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        overlayController = FloatingOverlayController(store: ReminderStore.shared)
    }
}
