import Foundation

struct ProjectSettings: Codable {
    var width: Int = 1080
    var height: Int = 1920
    var frameRate: Int = 30
    var duration: Double = 30

    static let presets: [ProjectSettings] = [
        .init(width: 1080, height: 1920, frameRate: 30, duration: 30),
        .init(width: 1080, height: 1920, frameRate: 60, duration: 30),
        .init(width: 1920, height: 1080, frameRate: 30, duration: 60),
        .init(width: 1920, height: 1080, frameRate: 60, duration: 60),
        .init(width: 1080, height: 1080, frameRate: 30, duration: 30),
        .init(width: 3840, height: 2160, frameRate: 30, duration: 60)
    ]

    var isValid: Bool {
        width > 0 && height > 0 &&
        (1...240).contains(frameRate) && duration > 0
    }
}
