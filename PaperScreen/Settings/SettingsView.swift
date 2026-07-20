import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: PaperSettings
    @ObservedObject var controller: PaperOverlayController

    var body: some View {
        Form {
            Text("Opacity")
            Slider(
                value: $settings.opacity,
                in: 0.05...0.4
            )
        }
        .padding()
    }
}
