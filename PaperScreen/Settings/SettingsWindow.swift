import SwiftUI
import AppKit

final class SettingsWindow: NSObject, NSWindowDelegate {

    static let shared = SettingsWindow()

    private var window: NSWindow?

    func show(settings: PaperSettings, controller: PaperOverlayController) {

        if window == nil {

            let view = SettingsView(
                settings: settings,
                controller: controller
            )

            let hostingView = NSHostingView(rootView: view)

            let newWindow = NSWindow(
                contentRect: NSRect(
                    x: 0,
                    y: 0,
                    width: 320,
                    height: 220
                ),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )

            newWindow.title = "PaperScreen Settings"
            newWindow.isReleasedWhenClosed = false
            newWindow.delegate = self
            newWindow.center()
            newWindow.contentView = hostingView

            window = newWindow

        } else {

            // Refresh the SwiftUI view in case settings changed
            window?.contentView = NSHostingView(
                rootView: SettingsView(
                    settings: settings,
                    controller: controller
                )
            )

        }

        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    // Instead of closing, just hide the window.
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        return false
    }

}
