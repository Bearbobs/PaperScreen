import SwiftUI
import AppKit

struct AppPickerView: View {
    @Binding var excludedBundleIdentifiers: Set<String>

    @State private var installedApps: [AppInfo] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Disable overlay for apps:")
                .font(.subheadline)

            if excludedBundleIdentifiers.isEmpty {
                Text("No apps excluded.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(installedApps.filter { excludedBundleIdentifiers.contains($0.bundleIdentifier) }) { app in
                    HStack {
                        if let icon = app.icon {
                            Image(nsImage: icon)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .cornerRadius(3)
                        }
                        Text(app.name)
                        Spacer()
                        Button(role: .destructive) {
                            excludedBundleIdentifiers.remove(app.bundleIdentifier)
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Divider()

            HStack {
                Text("Add app")
                    .font(.subheadline)
                Spacer()

                Menu {
                    ForEach(installedApps.sorted { $0.name < $1.name }) { app in
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
        }
        .onAppear(perform: loadInstalledApps)
    }

    private func loadInstalledApps() {
        var apps: [AppInfo] = []
        let fileManager = FileManager.default
        let appDirectories = ["/Applications", NSHomeDirectory() + "/Applications"]

        for dir in appDirectories {
            guard let contents = try? fileManager.contentsOfDirectory(atPath: dir) else { continue }
            for item in contents where item.hasSuffix(".app") {
                let url = URL(fileURLWithPath: dir).appendingPathComponent(item)
                if let appInfo = AppInfo(url: url) {
                    apps.append(appInfo)
                }
            }
        }

        installedApps = Array(Set(apps)).sorted { $0.name < $1.name }
    }
}

#Preview {
    AppPickerView(excludedBundleIdentifiers: .constant([]))
        .frame(width: 400, height: 400)
        .padding()
}
