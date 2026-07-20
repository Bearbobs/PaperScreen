import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: PaperSettings
    @ObservedObject var controller: PaperOverlayController

    var body: some View {
        Form {
            Text("Opacity")
            Slider(value: Binding(
                get: { settings.opacity },
                set: {
                    settings.opacity = $0
                    controller.setOpacity(CGFloat($0))
                }), in: 0.05...0.4)
        }
        .padding()
    }
}
