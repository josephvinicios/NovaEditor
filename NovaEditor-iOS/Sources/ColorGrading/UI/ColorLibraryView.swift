import SwiftUI

struct ColorLibraryView: View {
    @StateObject private var store = ColorLUTStore()
    @State private var showingImporter = false
    @State private var message = "Importe LUTs .cube ou analise presets .ffx."
    @State private var inspection: FFXInspection?

    var body: some View {
        NavigationView {
            List {
                Section("Biblioteca") {
                    ForEach(store.items) { lut in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(lut.name).font(.headline)
                            Text("\(lut.dimension) × \(lut.dimension) × \(lut.dimension) • \(lut.values.count) pontos")
                                .font(.caption).foregroundColor(.secondary)
                        }
                    }
                    .onDelete { offsets in
                        offsets.map { store.items[$0].id }.forEach(store.remove)
                    }
                }
                Section("Importação") {
                    Button {
                        showingImporter = true
                    } label: {
                        Label("Importar LUT ou analisar FFX", systemImage: "square.and.arrow.down")
                    }
                    Text(message).font(.caption).foregroundColor(.secondary)
                    if let report = inspection {
                        Text(report.explanation)
                        Text("Arquivo: \(report.fileName) • \(report.byteCount) bytes")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Colorings")
            .toolbar { EditButton() }
            .sheet(isPresented: $showingImporter) {
                ColorFileImporter { url in
                    handleImport(url)
                    showingImporter = false
                }
            }
        }
    }

    private func handleImport(_ url: URL) {
        let kind = ColorFileInspector().inspect(url)
        do {
            switch kind {
            case .cube:
                let lut = try ColorImportService().importLUT(from: url)
                try store.add(lut)
                message = "LUT \(lut.name) importada com sucesso."
            case .ffx:
                inspection = try ColorImportService().inspectFFX(from: url)
                message = "Análise FFX concluída. Conversão automática ainda não está disponível."
            case .unsupported:
                message = "Formato não suportado."
            }
        } catch {
            message = error.localizedDescription
        }
    }
}
