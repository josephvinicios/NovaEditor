import SwiftUI

struct EffectCatalogView: View {
    let onSelect: (EffectDefinition) -> Void
    @Environment(\.dismiss) private var dismiss

    private var categories: [String] {
        Array(Set(EffectCatalog.all.map { $0.category })).sorted()
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.self) { category in
                    Section(category) {
                        ForEach(
                            EffectCatalog.all.filter { $0.category == category }
                        ) { effect in
                            Button {
                                onSelect(effect)
                                dismiss()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(effect.name)
                                            .foregroundColor(.primary)
                                        Text("\(effect.parameters.count) parâmetros")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Biblioteca de efeitos")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Concluir") { dismiss() }
                }
            }
        }
    }
}
