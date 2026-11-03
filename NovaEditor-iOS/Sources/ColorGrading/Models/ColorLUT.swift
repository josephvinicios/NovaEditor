import Foundation

struct ColorLUT: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var dimension: Int
    var domainMin: SIMD3<Float> = SIMD3<Float>(repeating: 0)
    var domainMax: SIMD3<Float> = SIMD3<Float>(repeating: 1)
    var values: [SIMD3<Float>]
    var sourceFile: String
    var createdAt: Date = Date()

    var expectedValueCount: Int {
        dimension * dimension * dimension
    }

    var isValid: Bool {
        dimension >= 2 &&
        dimension <= 64 &&
        values.count == expectedValueCount &&
        domainMax.x > domainMin.x &&
        domainMax.y > domainMin.y &&
        domainMax.z > domainMin.z
    }
}
