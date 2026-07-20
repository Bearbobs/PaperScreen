import SwiftUI
import AppKit

final class SettingsWindow {
    static let shared = SettingsWindow()
    private var window: NSWindow?

    func show(settings: PaperSettings, controller: PaperOverlayController) {
        let view = SettingsView(settings: settings, controller: controller)
        if window == nil {
            window = NSWindow(contentRect: NSRect(x:0,y:0,width:300,height:180),
                              styleMask:[.titled,.closable],
                              backing:.buffered,defer:false)
        }
        window?.contentView = NSHostingView(rootView: view)
        window?.makeKeyAndOrderFront(nil)
    }
}
