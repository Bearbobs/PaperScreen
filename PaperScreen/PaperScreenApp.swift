import SwiftUI

@main
struct PaperScreenApp: App {
    @StateObject private var settings = PaperSettings()
    @StateObject private var controller = PaperOverlayController()

    var body: some Scene {
        MenuBarExtra("Paper", systemImage: "doc.text") {
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
