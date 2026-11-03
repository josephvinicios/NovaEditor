import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins

enum EffectBlendProcessor {
    static func composite(
        original: CIImage,
        processed: CIImage,
        settings: EffectRenderSettings
    ) -> CIImage {
        if settings.bypass { return original }

        let amount = min(max(settings.opacity, 0), 1)
        if amount <= 0 { return original }
        if amount >= 1 && settings.blendMode == .normal {
            return processed
        }

        let filter: CIFilter

        switch settings.blendMode {
        case .normal:
            filter = CIFilter.dissolveTransition()
            filter.setValue(original, forKey: kCIInputImageKey)
            filter.setValue(processed, forKey: kCIInputTargetImageKey)
            filter.setValue(amount, forKey: kCIInputTimeKey)
            return filter.outputImage ?? original

        case .multiply:
            filter = CIFilter.multiplyBlendMode()
        case .screen:
            filter = CIFilter.screenBlendMode()
        case .overlay:
            filter = CIFilter.overlayBlendMode()
        case .softLight:
            filter = CIFilter.softLightBlendMode()
        case .add:
            filter = CIFilter.additionCompositing()
        case .difference:
            filter = CIFilter.differenceBlendMode()
        }

        filter.setValue(processed, forKey: kCIInputImageKey)
        filter.setValue(original, forKey: kCIInputBackgroundImageKey)

        guard let blended = filter.outputImage else {
            return original
        }

        let transition = CIFilter.dissolveTransition()
        transition.inputImage = original
        transition.targetImage = blended
        transition.time = Float(amount)

        return transition.outputImage ?? original
    }
}
