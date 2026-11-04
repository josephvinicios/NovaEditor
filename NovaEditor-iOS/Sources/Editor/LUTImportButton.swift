import SwiftUI
import UniformTypeIdentifiers

struct LUTImportButton: View {
    var onMessage: (String) -> Void
    var onLoad: (CubeLUT) -> Void
    @State private var showing = false

    var body: some View {
        Button("LUT") { showing = true }
            .fileImporter(
                isPresented: $showing,
                allowedContentTypes: [.data],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .failure(let error):
                    onMessage("ERRO LUT: \(error.localizedDescription)")
                case .success(let urls):
                    guard let url = urls.first else { return }
                    let access = url.startAccessingSecurityScopedResource()
                    defer { if access { url.stopAccessingSecurityScopedResource() } }
                    do {
                        let text = (try? String(contentsOf: url, encoding: .utf8))
                            ?? (try String(contentsOf: url, encoding: .isoLatin1))
                        let lut = try CubeLUT.parse(text)
                        onLoad(lut)
                        let name = lut.title.isEmpty ? url.lastPathComponent : lut.title
                        onMessage("LUT carregado: \(name) (\(lut.size)³)")
                    } catch {
                        onMessage("ERRO LUT: \(error.localizedDescription)")
                    }
                }
            }
    }
}
