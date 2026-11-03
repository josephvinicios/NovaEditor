import SwiftUI

struct PlaybackControls: View {
    @ObservedObject var playback: TimelinePlayback

    var body: some View {
        HStack(spacing: 22) {
            Button {
                playback.seek(to: 0)
            } label: {
                Image(systemName: "backward.end.fill")
            }

            Button {
                playback.isPlaying
                    ? playback.pause()
                    : playback.play()
            } label: {
                Image(systemName: playback.isPlaying
                      ? "pause.fill" : "play.fill")
                    .font(.title2)
            }

            Button {
                playback.seek(to: playback.currentTime + 1.0 / 30.0)
            } label: {
                Image(systemName: "forward.frame.fill")
            }

            Text(String(format: "%.2fs", playback.currentTime))
                .monospacedDigit()
                .font(.caption)
        }
        .buttonStyle(.plain)
    }
}
