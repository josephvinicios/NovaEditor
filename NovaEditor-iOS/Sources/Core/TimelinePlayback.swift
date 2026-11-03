import Foundation
import Combine

final class TimelinePlayback: ObservableObject {
    @Published var currentTime: Double = 0
    @Published var isPlaying = false

    private var timer: AnyCancellable?
    private var lastTick = Date()
    var duration: Double = 30

    deinit {
        timer?.cancel()
    }

    deinit {
        timer?.cancel()
    }

    func play() {
        guard !isPlaying else { return }
        isPlaying = true
        lastTick = Date()

        timer = Timer.publish(
            every: 1.0 / 30.0,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            guard let self else { return }
            let now = Date()
            let delta = now.timeIntervalSince(self.lastTick)
            self.lastTick = now
            self.currentTime = min(
                self.duration,
                self.currentTime + delta
            )

            if self.currentTime >= self.duration {
                self.pause()
            }
        }
    }

    func pause() {
        isPlaying = false
        timer?.cancel()
        timer = nil
    }

    func seek(to time: Double) {
        currentTime = min(max(0, time), duration)
        lastTick = Date()
    }
}
