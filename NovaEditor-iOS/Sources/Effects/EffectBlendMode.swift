import Foundation

enum EffectBlendMode: String, Codable, CaseIterable {
    case normal
    case multiply
    case screen
    case overlay
    case softLight
    case add
    case difference
}

struct EffectRenderSettings: Codable {
    var blendMode: EffectBlendMode = .normal
    var opacity: Double = 1
    var bypass: Bool = false

    mutating func normalize() {
        opacity = min(max(opacity, 0), 1)
    }
}
