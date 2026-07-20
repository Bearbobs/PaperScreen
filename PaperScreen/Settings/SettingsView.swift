import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: PaperSettings
    @ObservedObject var controller: PaperOverlayController

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Picker(
                    "Paper Type",
                    selection: $settings.texture
                ) {
                    ForEach(PaperTexture.allCases) { texture in
                        Text(texture.displayName)
                            .tag(texture)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                Section {
                    Text("Opacity")
                    Slider(
                        value: $settings.opacity,
                        in: 0.05...0.4
                    )
                }
            }
            .padding()

            Spacer(minLength: 0)

            Link(destination: URL(string: "https://github.com/Bearbobs")!) {
                HStack(spacing: 6) {
                    Image(systemName: "c.circle.fill")
                    Text("Bearbobs/PaperScreen")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
            }
            .padding(.bottom, 12)
        }
    }
}
