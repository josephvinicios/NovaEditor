import SwiftUI

struct PluginManagerView: View {
    @State private var plugins = PluginRegistry.shared.all
    @State private var status = "Gerenciador pronto"

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "puzzlepiece.extension")
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text("Nova Plugins")
                                .font(.headline)
                            Text("\(plugins.count) extensões instaladas")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button("Atualizar") {
                            loadPlugins()
                        }
                    }
                    .padding(.vertical, 6)
                }

                Section("Extensões") {
                    if plugins.isEmpty {
                        Text("Nenhum plugin instalado")
                            .foregroundColor(.secondary)
                    }

                    ForEach(plugins) { plugin in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(plugin.manifest.name)
                                    .font(.headline)
                                Spacer()
                                Toggle(
                                    "Ativo",
                                    isOn: enabledBinding(for: plugin.id)
                                )
                                .labelsHidden()
                            }

                            Text(plugin.manifest.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            HStack {
                                Text(plugin.manifest.kind.rawValue.uppercased())
                                Text("•")
                                Text("v\(plugin.manifest.version)")
                                Spacer()
                                Button("Remover", role: .destructive) {
                                    PluginRegistry.shared.remove(plugin.id)
                                    refresh()
                                }
                                .font(.caption)
                            }
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 5)
                    }
                }

                Section {
                    Text(status)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Plugins")
        }
    }

    private func enabledBinding(for id: String) -> Binding<Bool> {
        Binding(
            get: {
                plugins.first(where: { $0.id == id })?.enabled ?? false
            },
            set: { value in
                PluginRegistry.shared.setEnabled(value, for: id)
                refresh()
            }
        )
    }

    private func loadPlugins() {
        do {
            let count = try PluginPackageStore.shared.loadPackages()
            refresh()
            status = "\(count) pacote(s) carregado(s)"
        } catch {
            status = "Erro ao carregar pacotes: \(error.localizedDescription)"
        }
    }

    private func refresh() {
        plugins = PluginRegistry.shared.all
    }
}
