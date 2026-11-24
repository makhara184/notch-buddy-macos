import SwiftUI

/// Renders the animated character dropping down from the top screen edge on a swinging rope
/// with an interactive speech-bubble reminder card.
struct HangingCharacterView: View {
    @EnvironmentObject var store: ReminderStore
    @State private var isDropped = false
    @State private var swingAngle: Double = -5

    var body: some View {
        VStack(spacing: 0) {
            if let reminder = store.activeAlert {
                VStack(spacing: 0) {
                    // Anchor rope attached to the top edge / notch
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [Color.gray.opacity(0.6), Color.brown.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 3, height: isDropped ? 44 : 4)

                    // Swinging character avatar
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 62, height: 62)
                            .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
                            .overlay(
                                Circle().stroke(Color.white.opacity(0.45), lineWidth: 1.5)
                            )

                        Text(store.characterStyle.faceEmoji)
                            .font(.system(size: 36))
                    }
                    .offset(y: -4)

                    // Speech bubble reminder card
                    VStack(spacing: 10) {
                        HStack(spacing: 6) {
                            Text(reminder.emoji)
                            Text(reminder.title)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                        }

                        HStack(spacing: 10) {
                            Button("Snooze 5m") {
                                animateOut { store.snoozeActive(minutes: 5) }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)

                            Button("Done") {
                                animateOut { store.dismissActive() }
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.22), radius: 14, y: 6)
                    .padding(.top, 6)
                }
                .rotationEffect(.degrees(swingAngle), anchor: .top)
                .offset(y: isDropped ? 0 : -220)
                .onAppear {
                    withAnimation(.spring(response: 0.65, dampingFraction: 0.62)) {
                        isDropped = true
                    }
                    withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                        swingAngle = 5
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private func animateOut(completion: @escaping () -> Void) {
        withAnimation(.easeIn(duration: 0.28)) {
            isDropped = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            completion()
        }
    }
}
