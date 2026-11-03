import SwiftUI

struct LayerPropertiesPanel: View {
    @Binding var layer: EditorLayer
    let currentTime: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PROPRIEDADES")
                .font(.caption.bold())

            control("Posição X", value: $layer.transform.x, range: -1080...1080)
            control("Posição Y", value: $layer.transform.y, range: -1920...1920)
            control("Escala X", value: $layer.transform.scaleX, range: 0.1...3)
            control("Escala Y", value: $layer.transform.scaleY, range: 0.1...3)
            control("Rotação", value: $layer.transform.rotation, range: -360...360)
            control("Opacidade", value: $layer.transform.opacity, range: 0...1)

            Button("＋ Criar keyframes") {
                record("x", layer.transform.x)
                record("y", layer.transform.y)
                record("scaleX", layer.transform.scaleX)
                record("scaleY", layer.transform.scaleY)
                record("rotation", layer.transform.rotation)
                record("opacity", layer.transform.opacity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private func control(
        _ title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(title)
                Spacer()
                Text(String(format: "%.2f", value.wrappedValue))
                    .monospacedDigit()
            }
            .font(.caption)
            Slider(value: value, in: range)
        }
    }

    private func record(_ property: String, _ value: Double) {
        var frames = layer.keyframes[property] ?? []

        if let index = frames.firstIndex(where: {
            abs($0.time - currentTime) < 0.0001
        }) {
            frames[index].value = value
        } else {
            frames.append(Keyframe(time: currentTime, value: value))
        }

        layer.keyframes[property] = frames.sorted {
            $0.time < $1.time
        }
    }
}
