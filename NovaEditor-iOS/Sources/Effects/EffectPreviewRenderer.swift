import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

enum EffectPreviewRenderer {
    private static let context = CIContext()

    static func render(
        _ image: UIImage,
        effects: [EffectInstance]
    ) -> UIImage {
        guard var output = CIImage(image: image) else {
            return image
        }

        let originalExtent = output.extent

        for effect in effects where effect.enabled {
            let values = Dictionary(
                uniqueKeysWithValues: effect.parameters.map {
                    ($0.name.lowercased(), $0.value)
                }
            )

            switch effect.type.lowercased() {
            case "color":
                let filter = CIFilter.colorControls()
                filter.inputImage = output
                filter.brightness = Float(values["brightness"] ?? 0)
                filter.contrast = Float(values["contrast"] ?? 1)
                filter.saturation = Float(values["saturation"] ?? 1)
                output = filter.outputImage ?? output

            case "blur":
                let filter = CIFilter.gaussianBlur()
                filter.inputImage = output
                filter.radius = Float(values["radius"] ?? 0)
                output = (filter.outputImage ?? output)
                    .cropped(to: originalExtent)

            case "sharpen":
                let filter = CIFilter.sharpenLuminance()
                filter.inputImage = output
                filter.sharpness = Float(values["amount"] ?? 0)
                output = filter.outputImage ?? output

            case "hue":
                let filter = CIFilter.hueAdjust()
                filter.inputImage = output
                filter.angle = Float(values["angle"] ?? 0)
                output = filter.outputImage ?? output

            default:
                continue
            }
        }

        guard let cgImage = context.createCGImage(
            output.cropped(to: originalExtent),
            from: originalExtent
        ) else {
            return image
        }

        return UIImage(
            cgImage: cgImage,
            scale: image.scale,
            orientation: image.imageOrientation
        )
    }
}
