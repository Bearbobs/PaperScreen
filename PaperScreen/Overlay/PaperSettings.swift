import Foundation
import Combine

final class PaperSettings: ObservableObject {
    @Published var opacity: Double = 0.12
    @Published var warmth: Double = 0.10
}
