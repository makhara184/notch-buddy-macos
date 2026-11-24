import SwiftUI
import AppKit
import Combine

/// Manages a borderless, transparent, always-on-top panel pinned under the MacBook notch / top menu bar.
@MainActor
final class FloatingOverlayController {
    private var panel: NSPanel?
    private var cancellable: AnyCancellable?
    private let store: ReminderStore

    init(store: ReminderStore) {
        self.store = store
        cancellable = store.$activeAlert.sink { [weak self] alert in
            if alert != nil {
                self?.showOverlay()
            } else {
                self?.hideOverlay()
            }
        }
    }

    private func showOverlay() {
        guard let screen = NSScreen.main else { return }

        let panelWidth: CGFloat = 340
        let panelHeight: CGFloat = 230
        let originX = screen.frame.midX - (panelWidth / 2)
        let originY = screen.frame.maxY - panelHeight

        if panel == nil {
            let newPanel = NSPanel(
                contentRect: NSRect(x: originX, y: originY, width: panelWidth, height: panelHeight),
                styleMask: [.borderless, .nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            newPanel.level = .statusBar
            newPanel.backgroundColor = .clear
            newPanel.isOpaque = false
            newPanel.hasShadow = false
            newPanel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            newPanel.contentView = NSHostingView(
                rootView: HangingCharacterView().environmentObject(store)
            )
            panel = newPanel
        }

        panel?.setFrameOrigin(NSPoint(x: originX, y: originY))
        panel?.orderFrontRegardless()
    }

    private func hideOverlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            if self?.store.activeAlert == nil {
                self?.panel?.orderOut(nil)
            }
        }
    }
}
