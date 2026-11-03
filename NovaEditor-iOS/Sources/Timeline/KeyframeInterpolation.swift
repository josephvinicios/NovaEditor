import Foundation

enum KeyframeInterpolation {
    static func progress(
        _ t: Double,
        mode: String
    ) -> Double {
        let x = min(max(t, 0), 1)

        switch mode.lowercased() {
        case "easein":
            return x * x
        case "easeout":
            return 1 - pow(1 - x, 2)
        case "easeinout":
            return x < 0.5
                ? 2 * x * x
                : 1 - pow(-2 * x + 2, 2) / 2
        case "smooth":
            return x * x * (3 - 2 * x)
        case "step", "hold":
            return x < 1 ? 0 : 1
        default:
            return x
        }
    }

    static func value(
        from a: Keyframe,
        to b: Keyframe,
        at time: Double
    ) -> Double {
        let duration = b.time - a.time
        guard duration > 0 else { return b.value }

        let t = (time - a.time) / duration
        let p = progress(t, mode: a.interpolation)
        return a.value + (b.value - a.value) * p
    }
}
