import Foundation

enum LayerType: String, Codable {
    case video, image, audio, text, shape, composition
}

struct Keyframe: Codable, Identifiable {
    var id = UUID()
    var time: Double
    var value: Double
    var interpolation: String = "linear"
}

struct LayerTransform: Codable {
    var x: Double = 0
    var y: Double = 0
    var scaleX: Double = 1
    var scaleY: Double = 1
    var rotation: Double = 0
    var opacity: Double = 1
}

struct EditorLayer: Codable, Identifiable {
    var id = UUID()
    var name: String
    var type: LayerType
    var source: String?
    var startTime: Double = 0
    var duration: Double = 5
    var enabled: Bool = true
    var transform = LayerTransform()
    var keyframes: [String: [Keyframe]] = [:]
}

struct EditorProject: Codable, Identifiable {
    var id = UUID()
    var name: String
    var width: Int = 1080
    var height: Int = 1920
    var frameRate: Int = 30
    var duration: Double = 30
    var layers: [EditorLayer] = []
    var createdAt = Date()
    var modifiedAt = Date()

    mutating func addLayer(_ layer: EditorLayer) {
        layers.append(layer)
        modifiedAt = Date()
    }

    mutating func removeLayer(id: UUID) {
        layers.removeAll { $0.id == id }
        modifiedAt = Date()
    }

    mutating func moveLayer(from source: Int, to destination: Int) {
        guard layers.indices.contains(source),
              destination >= 0,
              destination < layers.count else { return }

        let layer = layers.remove(at: source)
        layers.insert(layer, at: destination)
        modifiedAt = Date()
    }
}
