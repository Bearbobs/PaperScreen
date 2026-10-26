import AppKit

enum ColorEPaperStyle: String, CaseIterable, Identifiable {
    case cotton
    case recycled
    case matte
    case newsprint

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .cotton: return "Cotton Art Paper"
        case .recycled: return "Handmade Recycled Paper"
        case .matte: return "Matte Magazine"
        case .newsprint: return "Newsprint"
        }
    }

    func profile(isDark: Bool) -> ColorEPaperProfile {
        // Native reference defaults at intensity 0.35; use only fields consumed by its painter.
        var profile: ColorEPaperProfile
        switch self {
        case .cotton:
            profile = ColorEPaperProfile(red: 0.72, green: 0.62, blue: 0.43,
                                        colorOpacity: 0.0337, textureOpacity: 0.06075,
                                        dimmingOpacity: 0.0344, textureLightness: 0.46)
        case .recycled:
            profile = ColorEPaperProfile(red: 0.68, green: 0.57, blue: 0.39,
                                        colorOpacity: 0.0364, textureOpacity: 0.0625,
                                        dimmingOpacity: 0.0398, textureLightness: 0.44)
        case .matte:
            profile = ColorEPaperProfile(red: 0.74, green: 0.66, blue: 0.50,
                                        colorOpacity: 0.0297, textureOpacity: 0.0075,
                                        dimmingOpacity: 0.027, textureLightness: 0.50)
        case .newsprint:
            profile = ColorEPaperProfile(red: 0.64, green: 0.55, blue: 0.38,
                                        colorOpacity: 0.0384, textureOpacity: 0.01565,
                                        dimmingOpacity: 0.0465, textureLightness: 0.42)
        }

        if isDark {
            let luminance = 0.2126 * profile.red + 0.7152 * profile.green + 0.0722 * profile.blue
            profile.colorOpacity = min(profile.colorOpacity, 0.022 / luminance)
            profile.textureOpacity *= 0.85
            profile.dimmingOpacity = min(profile.dimmingOpacity + 0.008, 0.16)
            profile.textureLightness = min(profile.textureLightness, 0.44)
        }
        return profile
    }
}

struct ColorEPaperProfile {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    var colorOpacity: CGFloat
    var textureOpacity: CGFloat
    var dimmingOpacity: CGFloat
    var textureLightness: CGFloat

    var tint: NSColor {
        NSColor(calibratedRed: red, green: green, blue: blue, alpha: colorOpacity)
    }
}
