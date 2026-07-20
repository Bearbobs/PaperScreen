import AppKit


enum PaperTexture: String, CaseIterable, Identifiable {

    case classicMatte
    case whisperWeave
    case sunbakedParchment
    case oldBook
    case recycledPaper
    case cottonFiber
    case newspaper
    case sketchPaper
    case handmade


    var id: String {
        rawValue
    }


    var displayName: String {

        switch self {

        case .classicMatte:
            return "Classic Matte"

        case .whisperWeave:
            return "Whisper Weave"

        case .sunbakedParchment:
            return "Sunbaked Parchment"

        case .oldBook:
            return "Old Book"

        case .recycledPaper:
            return "Recycled Paper"

        case .cottonFiber:
            return "Cotton Fiber"

        case .newspaper:
            return "Newspaper"

        case .sketchPaper:
            return "Sketch Paper"

        case .handmade:
            return "Handmade Paper"
        }
    }



    var settings:
    (
        grainScale: CGFloat,
        blurRadius: CGFloat,
        contrast: CGFloat,
        opacity: CGFloat,
        tint: NSColor,
        blendMode: String
    ) {


        switch self {


        case .classicMatte:

            return (
                1.0,
                0.5,
                1.05,
                0.18,
                NSColor(
                    calibratedWhite: 0.96,
                    alpha: 1
                ),
                "softLightBlendMode"
            )



        case .whisperWeave:

            return (
                2.0,
                0.25,
                1.15,
                0.12,
                NSColor(
                    calibratedWhite: 0.98,
                    alpha: 1
                ),
                "overlayBlendMode"
            )



        case .sunbakedParchment:

            return (
                1.2,
                0.8,
                1.0,
                0.22,
                NSColor(
                    calibratedRed: 0.93,
                    green: 0.82,
                    blue: 0.62,
                    alpha: 1
                ),
                "multiplyBlendMode"
            )



        case .oldBook:

            return (
                0.8,
                1.0,
                1.1,
                0.20,
                NSColor(
                    calibratedRed: 0.88,
                    green: 0.80,
                    blue: 0.65,
                    alpha: 1
                ),
                "multiplyBlendMode"
            )



        case .recycledPaper:

            return (
                1.8,
                0.6,
                1.2,
                0.15,
                NSColor(
                    calibratedRed: 0.91,
                    green: 0.90,
                    blue: 0.84,
                    alpha: 1
                ),
                "softLightBlendMode"
            )



        case .cottonFiber:

            return (
                3.0,
                0.3,
                1.05,
                0.10,
                NSColor.white,
                "softLightBlendMode"
            )



        case .newspaper:

            return (
                4.0,
                0.15,
                1.25,
                0.20,
                NSColor(
                    calibratedWhite: 0.92,
                    alpha: 1
                ),
                "multiplyBlendMode"
            )



        case .sketchPaper:

            return (
                2.5,
                0.45,
                1.08,
                0.13,
                NSColor(
                    calibratedWhite: 0.97,
                    alpha: 1
                ),
                "overlayBlendMode"
            )



        case .handmade:

            return (
                0.7,
                1.2,
                1.15,
                0.25,
                NSColor(
                    calibratedRed: 0.95,
                    green: 0.88,
                    blue: 0.74,
                    alpha: 1
                ),
                "softLightBlendMode"
            )
        }
    }
}
