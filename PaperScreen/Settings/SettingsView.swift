import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: PaperSettings
    @ObservedObject var controller: PaperOverlayController

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Paper Style") {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("Paper Type", selection: $settings.texture) {
                            ForEach(PaperTexture.allCases) { texture in
                                Text(texture.displayName)
                                    .tag(texture)
                            }
                        }
                        .pickerStyle(.menu)

                        VStack(alignment: .leading, spacing: 10) {
                            settingSlider(
                                title: "Opacity",
                                valueText: "\(Int(settings.opacity * 100))%",
                                value: $settings.opacity,
                                range: 0.05...0.4
                            )

                            settingSlider(
                                title: "Grain Size",
                                valueText: String(format: "%.2fx", settings.grainSize),
                                value: $settings.grainSize,
                                range: 0.5...2.0
                            )

                            settingSlider(
                                title: "Sharpness",
                                valueText: String(format: "%.2fx", settings.textureSharpness),
                                value: $settings.textureSharpness,
                                range: 0.5...2.0
                            )
                        }
                    }
                    .padding(.top, 4)
                }

                GroupBox("Per-App Options") {
                    AppPickerView(
                        excludedBundleIdentifiers: $settings.excludedBundleIdentifiers
                    )
                    .padding(.top, 4)
                }

                Link(destination: URL(string: "https://github.com/Bearbobs")!) {
                    HStack(spacing: 6) {
                        Image(systemName: "c.circle.fill")
                        Text("Bearbobs/PaperScreen")
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(20)
        }
        .frame(minWidth: 480, idealWidth: 560, minHeight: 420, idealHeight: 560, alignment: .topLeading)
    }

    private func settingSlider(
        title: String,
        valueText: String,
        value: Binding<Double>,
        range: ClosedRange<Double>
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text(valueText)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            Slider(value: value, in: range)
        }
    }
}
