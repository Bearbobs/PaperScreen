import AppKit

enum PaperDisplayMode: String, CaseIterable, Identifiable {
    case standard
    case colorEPaper
    case softLight

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .standard: return "Default"
        case .colorEPaper: return "Color E-paper"
        case .softLight: return "Soft Light"
        }
    }

    var explanation: String {
        switch self {
        case .standard:
            return "The original overlay texture with no additional effects."
        case .colorEPaper:
            return "Paper tone, dimming, and fine surface texture over your selected overlay."
        case .softLight:
            return "A warm tint over your selected overlay texture, with adjustable color and intensity."
        }
    }
}

enum SoftLightScene: String, CaseIterable, Identifiable {
    case natural
    case warm
    case deepAmber

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .natural: return "Natural"
        case .warm: return "Warm"
        case .deepAmber: return "Deep Amber"
        }
    }

    var tint: NSColor {
        switch self {
        case .natural:
            return NSColor(srgbRed: 1, green: 0.96, blue: 0.86, alpha: 1)
        case .warm:
            return NSColor(srgbRed: 1, green: 0.78, blue: 0.46, alpha: 1)
        case .deepAmber:
            return NSColor(srgbRed: 1, green: 0.55, blue: 0.20, alpha: 1)
        }
    }
}
