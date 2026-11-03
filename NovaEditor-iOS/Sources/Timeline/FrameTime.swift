import Foundation

struct FrameTime {
    let frameRate: Int

    init(frameRate: Int) {
        self.frameRate = max(1, frameRate)
    }

    func seconds(forFrame frame: Int) -> Double {
        Double(frame) / Double(frameRate)
    }

    func frame(at seconds: Double) -> Int {
        Int((max(0, seconds) * Double(frameRate)).rounded())
    }

    func quantize(_ seconds: Double) -> Double {
        self.seconds(forFrame: frame(at: seconds))
    }

    func nextFrame(after seconds: Double) -> Double {
        self.seconds(forFrame: frame(at: seconds) + 1)
    }

    func previousFrame(before seconds: Double) -> Double {
        self.seconds(forFrame: max(0, frame(at: seconds) - 1))
    }
}
