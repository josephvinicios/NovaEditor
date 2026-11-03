import Foundation

struct CubeLUTParser {
    func parse(data: Data, fileName: String) throws -> ColorLUT {
        guard let text = String(data: data, encoding: .utf8) else {
            throw LUTImportError.unreadableFile
        }

        var name = URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent
        var dimension: Int?
        var domainMin = SIMD3<Float>(repeating: 0)
        var domainMax = SIMD3<Float>(repeating: 1)
        var values: [SIMD3<Float>] = []

        for rawLine in text.components(separatedBy: .newlines) {
            let line = rawLine.trimmingCharacters(in: .whitespaces)
            if line.isEmpty || line.hasPrefix("#") { continue }
            let parts = line.split(whereSeparator: { $0.isWhitespace })
            guard let key = parts.first else { continue }

            switch key.uppercased() {
            case "TITLE":
                name = parts.dropFirst().joined(separator: " ")
                    .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            case "LUT_3D_SIZE":
                guard parts.count == 2, let size = Int(parts[1]), (2...64).contains(size) else {
                    throw LUTImportError.invalidDimension
                }
                dimension = size
            case "DOMAIN_MIN", "DOMAIN_MAX":
                guard parts.count == 4,
                      let x = Float(parts[1]), let y = Float(parts[2]), let z = Float(parts[3]) else {
                    throw LUTImportError.invalidDomain
                }
                if key.uppercased() == "DOMAIN_MIN" {
                    domainMin = SIMD3(x, y, z)
                } else {
                    domainMax = SIMD3(x, y, z)
                }
            case "LUT_1D_SIZE":
                throw LUTImportError.unsupportedFormat
            default:
                if parts.count == 3,
                   let x = Float(parts[0]), let y = Float(parts[1]), let z = Float(parts[2]) {
                    values.append(SIMD3(x, y, z))
                }
            }
        }

        guard let size = dimension else { throw LUTImportError.invalidHeader }
        guard domainMax.x > domainMin.x, domainMax.y > domainMin.y,
              domainMax.z > domainMin.z else { throw LUTImportError.invalidDomain }

        let expected = size * size * size
        guard values.count == expected else {
            throw LUTImportError.invalidValues(expected: expected, actual: values.count)
        }

        let lut = ColorLUT(name: name, dimension: size, domainMin: domainMin,
                           domainMax: domainMax, values: values, sourceFile: fileName)
        guard lut.isValid else { throw LUTImportError.invalidHeader }
        return lut
    }
}
