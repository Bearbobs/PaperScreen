import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: PaperSettings
    @ObservedObject var controller: PaperOverlayController

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section(header: Text("Paper Style")) {
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

                    HStack {
                        Text("Opacity")
                        Slider(
                            value: $settings.opacity,
                            in: 0.05...0.4
                        )
                    }

                    HStack {
                        Text("Grain Size")
                        Slider(
                            value: $settings.grainSize,
                            in: 0.5...2.0
                        )
                    }

                    HStack {
                        Text("Sharpness")
                        Slider(
                            value: $settings.textureSharpness,
                            in: 0.5...2.0
                        )
                    }
                }

            }
            .padding(.top,24)
            .padding(.horizontal, 10)
            
            Section() {
                HStack {
                    Text("Per-App Option")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    AppPickerView(
                        excludedBundleIdentifiers: $settings.excludedBundleIdentifiers
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
            .padding(.bottom, 24)
        }
    }
}
