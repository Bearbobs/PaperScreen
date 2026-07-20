import SwiftUI
import AppKit

@main
struct PaperScreenApp: App {
    @StateObject private var settings: PaperSettings
    @StateObject private var controller: PaperOverlayController

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
        let settings = PaperSettings()

        _settings = StateObject(wrappedValue: settings)
        _controller = StateObject(
            wrappedValue: PaperOverlayController(settings: settings)
        )
    }

    var body: some Scene {
        MenuBarExtra("PaperScreen", systemImage: "display")  {
            Toggle("Enabled", isOn: $controller.enabled)
            Divider()
            Button("Settings") {
                SettingsWindow.shared.show(settings: settings, controller: controller)
            }
            Divider()
            Button("Quit") { NSApplication.shared.terminate(nil) }
        }
    }
}
