import SwiftUI
import AppKit

final class SettingsWindow: NSObject, NSWindowDelegate {

    static let shared = SettingsWindow()

    private var window: NSWindow?

    func show(settings: PaperSettings, controller: PaperOverlayController) {
        let hostingView = NSHostingView(
            rootView: SettingsView(
                settings: settings,
                controller: controller
            )
        )

        if window == nil {
            let newWindow = NSWindow(
                contentRect: NSRect(
                    x: 0,
                    y: 0,
                    width: 560,
                    height: 380
                ),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )

            newWindow.title = "PaperScreen Settings"
            newWindow.isReleasedWhenClosed = false
            newWindow.delegate = self
            newWindow.center()
            newWindow.contentView = hostingView
            newWindow.minSize = NSSize(width: 480, height: 420)

            window = newWindow
        } else {
            window?.contentView = hostingView
        }

        sizeWindowToFitContent()
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func sizeWindowToFitContent() {
        guard let window, let contentView = window.contentView else { return }

        contentView.layoutSubtreeIfNeeded()
        let fittingSize = contentView.fittingSize

        guard fittingSize.width > 0, fittingSize.height > 0 else { return }

        let targetSize = NSSize(
            width: max(480, ceil(fittingSize.width)),
            height: max(420, ceil(fittingSize.height))
        )

        window.setContentSize(targetSize)
    }

    // Instead of closing, just hide the window.
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        return false
    }
}
