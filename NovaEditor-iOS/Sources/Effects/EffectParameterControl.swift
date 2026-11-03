import SwiftUI

struct EffectParameterControl: View {
    @Binding var parameter: EffectParameter

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(parameter.name)
                Spacer()
                Text(parameter.value.formatted(.number.precision(.fractionLength(2))))
                    .monospacedDigit()
                    .foregroundColor(.secondary)
            }

            Slider(
                value: Binding(
                    get: { parameter.value },
                    set: { parameter.setValue($0) }
                ),
                in: parameter.minimum...parameter.maximum
            )
        }
        .font(.caption)
    }
}
