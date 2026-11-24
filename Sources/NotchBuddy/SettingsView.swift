import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: ReminderStore
    @State private var newTitle = ""
    @State private var newEmoji = "⏰"
    @State private var minutesFromNow = 10

    var body: some View {
        Form {
            Section("Character Appearance") {
                Picker("Hanging Buddy", selection: $store.characterStyle) {
                    ForEach(BuddyCharacterStyle.allCases) { style in
                        Text("\(style.faceEmoji) \(style.rawValue)").tag(style)
                    }
                }
                Toggle("Play chime sound on drop-down", isOn: $store.playSound)
            }

            Section("Schedule New Reminder") {
                TextField("Reminder message (e.g., Call client)", text: $newTitle)
                HStack {
                    TextField("Emoji", text: $newEmoji)
                        .frame(width: 60)
                    Stepper("In \(minutesFromNow) min", value: $minutesFromNow, in: 1...240)
                }
                Button("Add Reminder") {
                    guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    store.addQuickReminder(title: newTitle, minutes: minutesFromNow, emoji: newEmoji)
                    newTitle = ""
                }
                .buttonStyle(.borderedProminent)
            }

            Section("Active Queue (\(store.reminders.count))") {
                if store.reminders.isEmpty {
                    Text("No scheduled reminders yet.").foregroundStyle(.secondary)
                } else {
                    List {
                        ForEach(store.reminders) { item in
                            HStack {
                                Text("\(item.emoji) \(item.title)")
                                Spacer()
                                Text(item.dueDate, style: .relative)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .frame(height: 120)
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 420, height: 390)
    }
}
