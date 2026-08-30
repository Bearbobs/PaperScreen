import SwiftUI
import AppKit

struct AppPickerView: View {
    @Binding var excludedBundleIdentifiers: Set<String>

    @State private var installedApps: [AppInfo] = []
    @State private var manualBundleIdentifier = ""

    private var installedAppsByBundleIdentifier: [String: AppInfo] {
        Dictionary(uniqueKeysWithValues: installedApps.map { ($0.bundleIdentifier, $0) })
    }

    private var resolvedExcludedApps: [AppInfo] {
        excludedBundleIdentifiers
            .compactMap { installedAppsByBundleIdentifier[$0] }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    private var unresolvedExcludedBundleIdentifiers: [String] {
        excludedBundleIdentifiers
            .filter { installedAppsByBundleIdentifier[$0] == nil }
            .sorted()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Disable overlay for apps:")
                .font(.subheadline)

            if excludedBundleIdentifiers.isEmpty {
                Text("No apps excluded.")
                    .foregroundColor(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(resolvedExcludedApps) { app in
                        excludedAppRow(
                            name: app.name,
                            bundleIdentifier: app.bundleIdentifier,
                            icon: app.icon,
                            isUnavailable: false
                        ) {
                            excludedBundleIdentifiers.remove(app.bundleIdentifier)
                        }
                    }

                    ForEach(unresolvedExcludedBundleIdentifiers, id: \.self) { bundleIdentifier in
                        excludedAppRow(
                            name: "Unavailable App",
                            bundleIdentifier: bundleIdentifier,
                            icon: nil,
                            isUnavailable: true
                        ) {
                            excludedBundleIdentifiers.remove(bundleIdentifier)
                        }
                    }
                }
            }

            Divider()

            HStack {
                Text("Add app")
                    .font(.subheadline)
                Spacer()

                Menu {
                    ForEach(installedApps.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }) { app in
                        Button {
                            excludedBundleIdentifiers.insert(app.bundleIdentifier)
                        } label: {
                            HStack {
                                if let icon = app.icon {
                                    Image(nsImage: icon)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .cornerRadius(3)
                                }
                                VStack(alignment: .leading) {
                                    Text(app.name)
                                    Text(app.bundleIdentifier)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if excludedBundleIdentifiers.contains(app.bundleIdentifier) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("Choose app")
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                }
            }

            HStack(spacing: 8) {
                TextField("Or enter bundle ID", text: $manualBundleIdentifier)
                    .textFieldStyle(.roundedBorder)

                Button("Add") {
                    addManualBundleIdentifier()
                }
                .disabled(trimmedManualBundleIdentifier.isEmpty)
            }

            if !unresolvedExcludedBundleIdentifiers.isEmpty {
                Text("Unavailable apps are still excluded and can be removed by bundle ID.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear(perform: loadInstalledApps)
    }

    private var trimmedManualBundleIdentifier: String {
        manualBundleIdentifier.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func addManualBundleIdentifier() {
        let bundleIdentifier = trimmedManualBundleIdentifier
        guard !bundleIdentifier.isEmpty else { return }
        excludedBundleIdentifiers.insert(bundleIdentifier)
        manualBundleIdentifier = ""
    }

    @ViewBuilder
    private func excludedAppRow(
        name: String,
        bundleIdentifier: String,
        icon: NSImage?,
        isUnavailable: Bool,
        removeAction: @escaping () -> Void
    ) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Group {
                if let icon {
                    Image(nsImage: icon)
                        .resizable()
                } else {
                    Image(systemName: isUnavailable ? "app.slash" : "app")
                        .resizable()
                        .scaledToFit()
                        .padding(2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 16, height: 16)
            .cornerRadius(3)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(name)
                    if isUnavailable {
                        Text("Not found")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                Text(bundleIdentifier)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textSelection(.enabled)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            Spacer()

            Button(role: .destructive, action: removeAction) {
                Image(systemName: "minus.circle")
            }
            .buttonStyle(.plain)
        }
    }

    private func loadInstalledApps() {
        var appsByBundleIdentifier: [String: AppInfo] = [:]
        let fileManager = FileManager.default
        let appDirectories = ["/Applications", NSHomeDirectory() + "/Applications"]

        for dir in appDirectories {
            guard let enumerator = fileManager.enumerator(
                at: URL(fileURLWithPath: dir),
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            ) else {
                continue
            }

            for case let url as URL in enumerator {
                guard url.pathExtension == "app" else { continue }
                if let appInfo = AppInfo(url: url) {
                    appsByBundleIdentifier[appInfo.bundleIdentifier] = appInfo
                }
                enumerator.skipDescendants()
            }
        }

        installedApps = appsByBundleIdentifier.values.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }
}

#Preview {
    AppPickerView(excludedBundleIdentifiers: .constant([]))
        .frame(width: 400, height: 400)
        .padding()
}
