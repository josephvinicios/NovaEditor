import Foundation

enum TimelineMetrics {
    static func contentDuration(_ layers: [EditorLayer]) -> Double {
        layers.map { $0.startTime + $0.duration }.max() ?? 0
    }

    static func clamp(
        _ time: Double,
        duration: Double
    ) -> Double {
        min(max(0, time), max(0, duration))
    }

    static func layerEnd(_ layer: EditorLayer) -> Double {
        layer.startTime + layer.duration
    }

    static func overlaps(
        _ first: EditorLayer,
        _ second: EditorLayer
    ) -> Bool {
        first.startTime < layerEnd(second) &&
        second.startTime < layerEnd(first)
    }

    static func layersAt(
        _ time: Double,
        in layers: [EditorLayer]
    ) -> [EditorLayer] {
        layers.filter {
            $0.enabled &&
            time >= $0.startTime &&
            time < layerEnd($0)
        }
    }
}
