import Foundation

struct ColorGradeSettings: Codable, Hashable {
    var lutID: UUID?
    var intensity: Double = 1
    var enabled: Bool = true
    var exposure: Double = 0
    var contrast: Double = 1
    var saturation: Double = 1
    var temperature: Double = 0

    mutating func normalize() {
        intensity = min(1, max(0, intensity))
        exposure = min(4, max(-4, exposure))
        contrast = min(4, max(0, contrast))
        saturation = min(3, max(0, saturation))
        temperature = min(100, max(-100, temperature))
    }
}
