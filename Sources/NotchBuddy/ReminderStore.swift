import Foundation
import Combine
import AppKit

struct BuddyReminder: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var emoji: String
    var dueDate: Date
    var isCompleted: Bool = false

    init(id: UUID = UUID(), title: String, emoji: String = "🔔", dueDate: Date) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.dueDate = dueDate
    }
}

enum BuddyCharacterStyle: String, CaseIterable, Codable, Identifiable {
    case sloth = "Sleepy Sloth"
    case cat = "Notch Cat"
    case robot = "Mini Bot"
    case owl = "Focus Owl"

    var id: String { rawValue }

    var faceEmoji: String {
        switch self {
        case .sloth: return "🦥"
        case .cat: return "🐱"
        case .robot: return "🤖"
        case .owl: return "🦉"
        }
    }
}

@MainActor
final class ReminderStore: ObservableObject {
    static let shared = ReminderStore()

    @Published var reminders: [BuddyReminder] = []
    @Published var activeAlert: BuddyReminder?
    @Published var characterStyle: BuddyCharacterStyle = .cat
    @Published var playSound: Bool = true

    private var timer: Timer?

    private init() {
        startPolling()
    }

    func addQuickReminder(title: String, minutes: Int, emoji: String = "🔔") {
        let due = Date().addingTimeInterval(TimeInterval(minutes * 60))
        let item = BuddyReminder(title: title, emoji: emoji, dueDate: due)
        reminders.append(item)
        reminders.sort { $0.dueDate < $1.dueDate }
    }

    func triggerDemoReminder() {
        let demo = BuddyReminder(
            title: "Time for a 2-minute eye break!",
            emoji: "✨",
            dueDate: Date()
        )
        presentAlert(demo)
    }

    func snoozeActive(minutes: Int = 5) {
        guard let current = activeAlert else { return }
        activeAlert = nil
        addQuickReminder(title: current.title, minutes: minutes, emoji: current.emoji)
    }

    func dismissActive() {
        if let current = activeAlert {
            reminders.removeAll { $0.id == current.id }
        }
        activeAlert = nil
    }

    private func presentAlert(_ reminder: BuddyReminder) {
        activeAlert = reminder
        if playSound {
            NSSound(named: NSSound.Name("Glass"))?.play()
        }
    }

    private func startPolling() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.checkDueReminders()
            }
        }
    }

    private func checkDueReminders() {
        guard activeAlert == nil else { return }
        let now = Date()
        if let due = reminders.first(where: { !$0.isCompleted && $0.dueDate <= now }) {
            presentAlert(due)
        }
    }
}
