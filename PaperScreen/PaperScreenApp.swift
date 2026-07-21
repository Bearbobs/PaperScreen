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
        MenuBarExtra {
            VStack {
                // Header
                HStack {
                    Image("MenuBarIcon")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("PaperScreen")
                            .font(.headline)

                        Text(controller.enabled ? "Active" : "Paused")
                            .font(.caption)
                            .foregroundStyle(
                                controller.enabled ? .green : .secondary
                            )
                    }

                    Spacer()
                }
                .padding(.bottom, 8)

                Divider()
                Label(
                    controller.enabled ? "Paper Mode On" : "Paper Mode Off",
                    systemImage: controller.enabled
                        ? "checkmark.circle.fill"
                        : "circle"
                ).padding()
                
                
                // Quick info
                VStack(alignment: .leading, spacing: 6) {
                    Label {
                        Text("Opacity \(Int(settings.opacity * 100))%")
                    } icon: {
                        Image(systemName: "circle.lefthalf.filled")
                    }

                    Label {
                        Text(settings.texture.rawValue.capitalized)
                    } icon: {
                        Image(systemName: "square.3.layers.3d")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                Divider()

                
                Button {
                    controller.enabled.toggle()
                } label: {
                    Label(
                        controller.enabled ? "Disable PaperScreen" : "Enable PaperScreen",
                        systemImage: "power"
                    )
                }

                Divider()

                // Actions
                Button {
                    SettingsWindow.shared.show(
                        settings: settings,
                        controller: controller
                    )
                } label: {
                    Label("Settings…", systemImage: "slider.horizontal.3")
                }
                .keyboardShortcut(",")

                Divider()

                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Label("Quit PaperScreen", systemImage: "power.circle")
                }
                .keyboardShortcut("q")
            }
            .padding(8)

        } label: {
            Image("MenuBarIcon")
                .renderingMode(.template)
                .opacity(controller.enabled ? 1.0 : 0.4)
        }
        .menuBarExtraStyle(.window)
    }
}
