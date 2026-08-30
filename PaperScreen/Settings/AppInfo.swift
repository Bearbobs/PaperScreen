import AppKit

struct AppInfo: Identifiable, Hashable {
    let id: String
    let name: String
    let bundleIdentifier: String
    let icon: NSImage?

    init?(url: URL) {
        guard let bundle = Bundle(url: url),
              let bundleID = bundle.bundleIdentifier else {
            return nil
        }
        self.bundleIdentifier = bundleID
        self.id = bundleID

        let displayName = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? bundle.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? url.deletingPathExtension().lastPathComponent
        self.name = displayName

        self.icon = NSWorkspace.shared.icon(forFile: url.path)
    }
}
