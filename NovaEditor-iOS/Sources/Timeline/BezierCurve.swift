import Foundation

struct BezierCurve: Codable {
    var control1: Double = 0.25
    var control2: Double = 0.75

    func sample(_ t: Double) -> Double {
        let x = min(max(t, 0), 1)
        let u = 1 - x

        return 3 * u * u * x * control1
             + 3 * u * x * x * control2
             + x * x * x
    }

    func interpolate(from start: Double, to end: Double, at t: Double) -> Double {
        let p = sample(t)
        return start + (end - start) * p
    }
}
