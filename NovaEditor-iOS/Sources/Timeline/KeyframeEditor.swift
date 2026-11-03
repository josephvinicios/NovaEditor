import Foundation

enum KeyframeEditor {
    static func insert(
        _ frame: Keyframe,
        into frames: inout [Keyframe],
        tolerance: Double = 0.0001
    ) {
        if let index = frames.firstIndex(where: {
            abs($0.time - frame.time) <= tolerance
        }) {
            frames[index].value = frame.value
            frames[index].interpolation = frame.interpolation
        } else {
            frames.append(frame)
        }

        frames.sort { $0.time < $1.time }
    }

    static func remove(at time: Double, from frames: inout [Keyframe]) {
        frames.removeAll { abs($0.time - time) <= 0.0001 }
    }

    static func shift(
        _ frames: inout [Keyframe],
        by offset: Double
    ) {
        for index in frames.indices {
            frames[index].time = max(0, frames[index].time + offset)
        }
        frames.sort { $0.time < $1.time }
    }

    static func duplicate(_ frames: [Keyframe], offset: Double) -> [Keyframe] {
        frames.map {
            Keyframe(
                time: max(0, $0.time + offset),
                value: $0.value,
                interpolation: $0.interpolation
            )
        }
    }
}
