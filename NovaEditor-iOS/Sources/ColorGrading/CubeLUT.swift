import UIKit
import CoreImage

struct CubeLUT {
    let id = UUID()
    let title: String
    let size: Int
    let data: Data

    struct ParseError: LocalizedError {
        let message: String
        var errorDescription: String? { message }
    }

    private static let context = CIContext()

    static func parse(_ text: String) throws -> CubeLUT {
        var size = 0
        var title = ""
        var domainMin: [Float] = [0, 0, 0]
        var domainMax: [Float] = [1, 1, 1]
        var values: [Float] = []

        for raw in text.components(separatedBy: .newlines) {
            let line = raw.trimmingCharacters(in: .whitespaces)
            if line.isEmpty || line.hasPrefix("#") { continue }
            let parts = line.split(whereSeparator: { $0 == " " || $0 == "\t" }).map(String.init)
            switch parts[0] {
            case "TITLE":
                title = parts.dropFirst().joined(separator: " ")
                    .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            case "LUT_3D_SIZE":
                size = parts.count > 1 ? (Int(parts[1]) ?? 0) : 0
            case "LUT_1D_SIZE":
                throw ParseError(message: "LUT 1D ainda não suportado")
            case "DOMAIN_MIN":
                let v = parts.dropFirst().compactMap { Float($0) }
                if v.count == 3 { domainMin = v }
            case "DOMAIN_MAX":
                let v = parts.dropFirst().compactMap { Float($0) }
                if v.count == 3 { domainMax = v }
            default:
                if parts.count >= 3,
                   let r = Float(parts[0]), let g = Float(parts[1]), let b = Float(parts[2]) {
                    values += [r, g, b]
                }
            }
        }

        guard size >= 2 else {
            throw ParseError(message: "LUT_3D_SIZE ausente ou inválido")
        }
        let count = size * size * size
        guard values.count == count * 3 else {
            throw ParseError(message: "Esperava \(count) linhas, achei \(values.count / 3)")
        }

        var rgba: [Float] = []
        rgba.reserveCapacity(count * 4)
        for i in 0..<count {
            for c in 0..<3 {
                let range = domainMax[c] - domainMin[c]
                let raw = values[i * 3 + c]
                let v = range == 0 ? raw : (raw - domainMin[c]) / range
                rgba.append(min(max(v, 0), 1))
            }
            rgba.append(1)
        }
        let data = rgba.withUnsafeBufferPointer { Data(buffer: $0) }
        return CubeLUT(title: title, size: size, data: data)
    }

    func apply(to image: UIImage, intensity: Double = 1) -> UIImage {
        guard let cg = image.cgImage,
              let filter = CIFilter(name: "CIColorCubeWithColorSpace") else { return image }
        let input = CIImage(cgImage: cg)
        filter.setValue(size, forKey: "inputCubeDimension")
        filter.setValue(data, forKey: "inputCubeData")
        filter.setValue(CGColorSpace(name: CGColorSpace.sRGB), forKey: "inputColorSpace")
        filter.setValue(input, forKey: kCIInputImageKey)
        guard var output = filter.outputImage else { return image }

        if intensity < 1, let mix = CIFilter(name: "CIDissolveTransition") {
            mix.setValue(input, forKey: kCIInputImageKey)
            mix.setValue(output, forKey: kCIInputTargetImageKey)
            mix.setValue(max(0, intensity), forKey: kCIInputTimeKey)
            if let mixed = mix.outputImage { output = mixed }
        }

        guard let result = Self.context.createCGImage(output, from: input.extent) else { return image }
        return UIImage(cgImage: result, scale: image.scale, orientation: image.imageOrientation)
    }
}
