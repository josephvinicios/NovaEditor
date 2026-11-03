import SwiftUI

struct EffectStackView: View {
    let layerID: UUID

    @State private var effects: [EffectInstance] = []
    @State private var selectedEffectID: UUID?
    @State private var showingCatalog = false

    var body: some View {
        List {
            Section {
                Button {
                    showingCatalog = true
                } label: {
                    Label("Adicionar efeito", systemImage: "plus.circle.fill")
                }
            }

            Section("Pilha de efeitos") {
                if effects.isEmpty {
                    Text("Nenhum efeito nesta camada")
                        .foregroundColor(.secondary)
                }

                ForEach(effects) { effect in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Button {
                                selectedEffectID = effect.id
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(effect.name)
                                        .foregroundColor(.primary)
                                    Text(effect.type.uppercased())
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Spacer()

                            Toggle(
                                "Ativo",
                                isOn: enabledBinding(effect.id)
                            )
                            .labelsHidden()
                        }

                        if selectedEffectID == effect.id {
                            parameterEditor(effect.id)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onMove(perform: moveEffects)
                .onDelete(perform: deleteEffects)
            }
        }
        .navigationTitle("Efeitos")
        .toolbar {
            EditButton()
        }
        .sheet(isPresented: $showingCatalog) {
            EffectCatalogView { definition in
                effects.append(definition.createInstance())
                persist()
                showingCatalog = false
            }
        }
        .onAppear {
            effects = EffectStackStore.shared.effects(for: layerID)
        }
    }

    private func persist() {
        EffectStackStore.shared.save(effects, for: layerID)
    }

    private func enabledBinding(_ id: UUID) -> Binding<Bool> {
        Binding(
            get: { effects.first(where: { $0.id == id })?.enabled ?? false },
            set: { value in
                guard let index = effects.firstIndex(where: { $0.id == id }) else { return }
                effects[index].enabled = value
                persist()
            }
        )
    }

    @ViewBuilder
    private func parameterEditor(_ id: UUID) -> some View {
        if let index = effects.firstIndex(where: { $0.id == id }) {
            ForEach(effects[index].parameters.indices, id: \.self) { parameterIndex in
                EffectParameterControl(
                    parameter: $effects[index].parameters[parameterIndex]
                )
                .onChange(of: effects[index].parameters[parameterIndex].value) { _ in
                    persist()
                }
            }
        }
    }

    private func moveEffects(from source: IndexSet, to destination: Int) {
        effects.move(fromOffsets: source, toOffset: destination)
        persist()
    }

    private func deleteEffects(at offsets: IndexSet) {
        effects.remove(atOffsets: offsets)
        persist()
    }
}
