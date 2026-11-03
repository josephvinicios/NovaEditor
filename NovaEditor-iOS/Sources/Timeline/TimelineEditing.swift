import Foundation

enum TimelineEditing {
    static func split(
        _ layer: EditorLayer,
        at time: Double
    ) -> (EditorLayer, EditorLayer)? {
        let local = time - layer.startTime
        guard local > 0.0001, local < layer.duration - 0.0001 else {
            return nil
        }

        var left = layer
        var right = layer

        left.duration = local
        right.id = UUID()
        right.name += " (Parte 2)"
        right.startTime = time
        right.duration = layer.duration - local

        for (property, frames) in layer.keyframes {
            left.keyframes[property] = frames.filter { $0.time <= time }
            right.keyframes[property] = frames.filter { $0.time >= time }
        }

        return (left, right)
    }

    static func trimStart(_ layer: inout EditorLayer, to time: Double) {
        let end = layer.startTime + layer.duration
        let newStart = min(max(time, layer.startTime), end)
        layer.duration = end - newStart
        layer.startTime = newStart
    }

    static func trimEnd(_ layer: inout EditorLayer, to time: Double) {
        let end = max(layer.startTime, time)
        layer.duration = end - layer.startTime
    }

    static func move(_ layer: inout EditorLayer, to time: Double) {
        layer.startTime = max(0, time)
    }
}
