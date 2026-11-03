import Foundation

struct TimelineEngine {
    var currentTime: Double = 0
    var isPlaying: Bool = false

    mutating func seek(to time: Double, duration: Double) {
        currentTime = min(max(0, time), max(0, duration))
    }

    mutating func play() {
        isPlaying = true
    }

    mutating func pause() {
        isPlaying = false
    }

    mutating func advance(by seconds: Double, duration: Double) {
        guard isPlaying else { return }

        currentTime += max(0, seconds)

        if currentTime >= duration {
            currentTime = max(0, duration)
            isPlaying = false
        }
    }

    func visibleLayers(in project: EditorProject) -> [EditorLayer] {
        project.layers.filter {
            $0.enabled &&
            currentTime >= $0.startTime &&
            currentTime <= $0.startTime + $0.duration
        }
    }

    func value(
        for property: String,
        in layer: EditorLayer,
        default defaultValue: Double
    ) -> Double {
        guard let frames = layer.keyframes[property],
              !frames.isEmpty else {
            return defaultValue
        }

        let sorted = frames.sorted { $0.time < $1.time }

        guard let first = sorted.first,
              let last = sorted.last else {
            return defaultValue
        }

        if currentTime <= first.time { return first.value }
        if currentTime >= last.time { return last.value }

        for index in 0..<(sorted.count - 1) {
            let a = sorted[index]
            let b = sorted[index + 1]

            if currentTime >= a.time && currentTime <= b.time {
                let range = b.time - a.time
                guard range > 0 else { return b.value }

                let progress = (currentTime - a.time) / range
                return a.value + (b.value - a.value) * progress
            }
        }

        return defaultValue
    }
}
