import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins

final class EffectProcessor {
    static let shared = EffectProcessor()

    private let context = CIContext()

    private init() {}

    func process(
        _ source: CIImage,
        effects: [EffectInstance]
    ) -> CIImage {
        var output = source

        for effect in effects where effect.enabled {
            output = apply(effect, to: output)
        }

        return output
    }

    private func value(
        _ id: String,
        in effect: EffectInstance,
        fallback: Double
    ) -> Double {
        effect.parameters.first(where: { $0.id == id })?.value ?? fallback
    }

    private func apply(
        _ effect: EffectInstance,
        to image: CIImage
    ) -> CIImage {
        switch effect.type {
        case "color":
            let filter = CIFilter.colorControls()
            filter.inputImage = image
            filter.brightness = Float(
                value("brightness", in: effect, fallback: 0)
            )
            filter.contrast = Float(
                value("contrast", in: effect, fallback: 1)
            )
            filter.saturation = Float(
                value("saturation", in: effect, fallback: 1)
            )
            return filter.outputImage ?? image

        case "blur":
            let filter = CIFilter.gaussianBlur()
            filter.inputImage = image
            filter.radius = Float(
                value("radius", in: effect, fallback: 0)
            )
            return (filter.outputImage ?? image).cropped(to: image.extent)

        case "sharpen":
            let filter = CIFilter.sharpenLuminance()
            filter.inputImage = image
            filter.sharpness = Float(
                value("amount", in: effect, fallback: 0.4)
            )
            return filter.outputImage ?? image

        case "hue":
            let filter = CIFilter.hueAdjust()
            filter.inputImage = image
            filter.angle = Float(
                value("angle", in: effect, fallback: 0)
            )
            return filter.outputImage ?? image

        default:
            return image
        }
    }

    func makeCGImage(from image: CIImage) -> CGImage? {
        context.createCGImage(image, from: image.extent)
    }
}
