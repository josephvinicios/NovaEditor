import SwiftUI

struct AMEffectCatalogTestView: View {
    @State private var defs: [AMEffectDefinition] = []
    @State private var failed: [String] = []
    @State private var query = ""

    private var filtered: [AMEffectDefinition] {
        guard !query.isEmpty else { return defs }
        let q = query.lowercased()
        return defs.filter {
            $0.name.lowercased().contains(q) || $0.nameEn.lowercased().contains(q) || $0.id.lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section("Resumo") {
                    Text("Carregados: \(defs.count)")
                    Text("Falharam: \(failed.count)")
                    ForEach(failed, id: \.self) { Text($0).font(.caption2).foregroundColor(.red) }
                }
                Section("Efeitos") {
                    ForEach(filtered) { d in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(d.name.isEmpty ? d.id : d.name)
                            Text("\(d.category) · \(d.params.count) params · shader \(d.shader.count) chars")
                                .font(.caption2).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .searchable(text: $query)
            .navigationTitle("Catálogo APK")
        }
        .onAppear {
            let r = AMEffectCatalog.loadAll()
            defs = r.defs
            failed = r.failed
        }
    }
}
