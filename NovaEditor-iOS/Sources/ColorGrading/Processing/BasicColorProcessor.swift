import CoreImage
import CoreImage.CIFilterBuiltins

struct BasicColorProcessor {
    func apply(_ settings: ColorGradeSettings, to image: CIImage) -> CIImage? {
        guard settings.enabled else { return image }
        let filter = CIFilter.colorControls()
        filter.inputImage = image
        filter.saturation = Float(settings.saturation)
        filter.contrast = Float(settings.contrast)

        guard let controlled = filter.outputImage else { return nil }

        let exposure = CIFilter.exposureAdjust()
        exposure.inputImage = controlled
        exposure.ev = Float(settings.exposure)
        guard let exposed = exposure.outputImage else { return nil }

        let temperature = CIFilter.temperatureAndTint()
        temperature.inputImage = exposed
        temperature.neutral = CIVector(x: 6500 + settings.temperature * 25, y: 0)
        temperature.targetNeutral = CIVector(x: 6500, y: 0)
        return temperature.outputImage
    }
}
