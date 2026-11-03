import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins

struct ColorLUTProcessor {
    func apply(_ lut: ColorLUT, to image: CIImage, intensity: Float = 1) -> CIImage? {
        guard lut.isValid else { return nil }
        let dimension = lut.dimension
        var cube: [Float] = []
        cube.reserveCapacity(lut.values.count * 4)

        for value in lut.values {
            cube.append(value.x)
            cube.append(value.y)
            cube.append(value.z)
            cube.append(1)
        }

        let data = cube.withUnsafeBufferPointer { buffer -> Data in
            guard let base = buffer.baseAddress else { return Data() }
            return Data(bytes: base, count: buffer.count * MemoryLayout<Float>.size)
        }

        let filter = CIFilter.colorCube()
        filter.inputImage = image
        filter.cubeDimension = Float(dimension)
        filter.cubeData = data
        guard let output = filter.outputImage else { return nil }

        let amount = CGFloat(min(1, max(0, intensity)))
        if amount >= 0.999 { return output }

        let blend = CIFilter.dissolveTransition()
        blend.inputImage = image
        blend.targetImage = output
        blend.time = Float(amount)
        return blend.outputImage
    }
}
