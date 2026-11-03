import Foundation

struct GraphPoint: Identifiable {
    let id: UUID
    var time: Double
    var value: Double

    init(id: UUID = UUID(), time: Double, value: Double) {
        self.id = id
        self.time = time
        self.value = value
    }
}

struct GraphData {
    static func points(
        from keyframes: [Keyframe]
    ) -> [GraphPoint] {
        keyframes.sorted { $0.time < $1.time }.map {
            GraphPoint(id: $0.id, time: $0.time, value: $0.value)
        }
    }

    static func bounds(_ points: [GraphPoint]) -> ClosedRange<Double> {
        guard let minValue = points.map(\.value).min(),
              let maxValue = points.map(\.value).max() else {
            return 0...1
        }

        if minValue == maxValue {
            return (minValue - 1)...(maxValue + 1)
        }
        return minValue...maxValue
    }
}
