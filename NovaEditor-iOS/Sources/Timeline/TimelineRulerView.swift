import SwiftUI

struct TimelineRulerView: View {
    let duration: Double
    let currentTime: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(0...Int(max(1, duration)), id: \.self) { second in
                    let x = CGFloat(second) / CGFloat(max(1, duration)) * geo.size.width

                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 1, height: 10)

                        Text("\(second)s")
                            .font(.system(size: 9))
                            .foregroundColor(.white.opacity(0.65))
                    }
                    .position(x: x, y: 12)
                }

                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2, height: 28)
                    .position(
                        x: CGFloat(currentTime / max(1, duration)) * geo.size.width,
                        y: 14
                    )
            }
        }
        .frame(height: 28)
    }
}
