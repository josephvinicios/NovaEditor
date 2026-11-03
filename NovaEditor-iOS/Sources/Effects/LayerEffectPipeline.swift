import UIKit

struct LayerEffectPipeline {
    private var cache: [String: UIImage] = [:]

    mutating func render(
        image: UIImage,
        layerID: UUID,
        effects: [EffectInstance]
    ) -> UIImage {
        let activeEffects = effects.filter(\.enabled)

        guard !activeEffects.isEmpty else {
            return image
        }

        let signature = activeEffects.map { effect in
            let parameters = effect.parameters
                .map { "\($0.name)=\($0.value)" }
                .joined(separator: ",")

            return "\(effect.type):\(parameters)"
        }
        .joined(separator: "|")

        let key = "\(layerID.uuidString):\(signature)"

        if let cached = cache[key] {
            return cached
        }

        let rendered = EffectPreviewRenderer.render(
            image,
            effects: activeEffects
        )

        cache[key] = rendered
        return rendered
    }

    mutating func clearCache() {
        cache.removeAll()
    }
}
