import SwiftUI
import AppKit

@main
struct PaperScreenApp: App {
    @StateObject private var settings: PaperSettings
    @StateObject private var controller: PaperOverlayController

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)

        let settings = PaperSettings(defaults: .standard)

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
                    "\(settings.mode.displayName) \(controller.enabled ? "On" : "Off")",
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
                        Text(settings.texture.displayName)
                    } icon: {
                        Image(systemName: "square.3.layers.3d")
                    }

                    if settings.mode == .softLight {
                        Label {
                            Text("Intensity \(Int(settings.softLightIntensity * 100))%")
                        } icon: {
                            Image(systemName: "circle.lefthalf.filled")
                        }

                        Label {
                            Text(settings.softLightScene.displayName)
                        } icon: {
                            Image(systemName: "sun.max")
                        }
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                Divider()

                Picker("Add-on Mode", selection: $settings.mode) {
                    ForEach(PaperDisplayMode.allCases) { mode in
                        Text(mode.displayName)
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()

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
            .frame(width: 340)

        } label: {
            Image("MenuBarIcon")
                .renderingMode(.template)
                .opacity(controller.enabled ? 1.0 : 0.4)
        }
        .menuBarExtraStyle(.window)
    }
}
