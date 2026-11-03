import Foundation

enum TimelineSnap {
    static func nearest(
        to time: Double,
        candidates: [Double],
        threshold: Double
    ) -> Double? {
        candidates
            .filter { abs($0 - time) <= threshold }
            .min { abs($0 - time) < abs($1 - time) }
    }

    static func snap(
        _ time: Double,
        frameRate: Int,
        otherLayers: [EditorLayer],
        threshold: Double = 0.08
    ) -> Double {
        let frameTime = FrameTime(frameRate: frameRate)
        var points: [Double] = [0]

        for layer in otherLayers {
            points.append(layer.startTime)
            points.append(layer.startTime + layer.duration)
        }

        if let match = nearest(
            to: time,
            candidates: points,
            threshold: threshold
        ) {
            return frameTime.quantize(match)
        }

        return frameTime.quantize(time)
    }
}
