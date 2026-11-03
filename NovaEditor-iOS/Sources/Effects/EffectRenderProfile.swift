import Foundation

enum EffectRenderQuality: String, Codable, CaseIterable {
    case draft
    case preview
    case high
    case maximum
}

struct EffectRenderProfile: Codable {
    var quality: EffectRenderQuality = .preview
    var maximumDimension: Int
    var allowsExpensiveEffects: Bool
    var usesIntermediateCache: Bool

    static func profile(for quality: EffectRenderQuality) -> Self {
        switch quality {
        case .draft:
            return .init(
                quality: quality,
                maximumDimension: 480,
                allowsExpensiveEffects: false,
                usesIntermediateCache: false
            )
        case .preview:
            return .init(
                quality: quality,
                maximumDimension: 720,
                allowsExpensiveEffects: true,
                usesIntermediateCache: true
            )
        case .high:
            return .init(
                quality: quality,
                maximumDimension: 1920,
                allowsExpensiveEffects: true,
                usesIntermediateCache: true
            )
        case .maximum:
            return .init(
                quality: quality,
                maximumDimension: 4096,
                allowsExpensiveEffects: true,
                usesIntermediateCache: true
            )
        }
    }
}
