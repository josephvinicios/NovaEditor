import Foundation

enum LayerDuplicator {
    static func duplicate(
        _ layer: EditorLayer,
        offset: Double = 0
    ) -> EditorLayer {
        var copy = layer
        copy.id = UUID()
        copy.name += " Cópia"
        copy.startTime = max(0, layer.startTime + offset)

        var newFrames: [String: [Keyframe]] = [:]
        for (property, frames) in layer.keyframes {
            newFrames[property] = frames.map {
                Keyframe(
                    time: $0.time,
                    value: $0.value,
                    interpolation: $0.interpolation
                )
            }
        }
        copy.keyframes = newFrames
        return copy
    }
}
