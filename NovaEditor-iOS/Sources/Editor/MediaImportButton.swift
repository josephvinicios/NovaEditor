import SwiftUI
import UniformTypeIdentifiers

struct MediaImportButton: View {
    var onMessage: (String) -> Void = { _ in }
    var onImport: ([EditorLayer]) -> Void
    @State private var showingPicker = false

    private static let videoExt: Set<String> = ["mp4", "mov", "m4v"]
    private static let audioExt: Set<String> = ["mp3", "m4a", "wav", "aac", "aiff", "caf"]
    private static let imageExt: Set<String> = ["png", "jpg", "jpeg", "webp", "heic", "gif"]

    var body: some View {
        Button("＋ Mídia") { showingPicker = true }
            .fileImporter(
                isPresented: $showingPicker,
                allowedContentTypes: [.movie, .image, .audio, .data],
                allowsMultipleSelection: true
            ) { result in
                switch result {
                case .failure(let error):
                    onMessage("ERRO picker: \(error.localizedDescription)")
                case .success(let urls):
                    importFiles(urls)
                }
            }
    }

    private func importFiles(_ urls: [URL]) {
        let manager = FileManager.default
        guard let docs = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            onMessage("ERRO: sem pasta Documents")
            return
        }
        let folder = docs.appendingPathComponent("NovaMedia")
        do {
            try manager.createDirectory(at: folder, withIntermediateDirectories: true)
        } catch {
            onMessage("ERRO pasta: \(error.localizedDescription)")
            return
        }

        var layers: [EditorLayer] = []
        var firstError: String?
        var skipped = 0

        for url in urls {
            let access = url.startAccessingSecurityScopedResource()
            defer { if access { url.stopAccessingSecurityScopedResource() } }

            let ext = url.pathExtension.lowercased()
            let type: LayerType
            if Self.videoExt.contains(ext) { type = .video }
            else if Self.audioExt.contains(ext) { type = .audio }
            else if Self.imageExt.contains(ext) { type = .image }
            else { skipped += 1; continue }

            let unique = UUID().uuidString.prefix(6)
            let name = url.deletingPathExtension().lastPathComponent
            let destination = folder.appendingPathComponent("\(unique)-\(url.lastPathComponent)")
            do {
                try manager.copyItem(at: url, to: destination)
                layers.append(EditorLayer(name: name, type: type, source: destination.path))
            } catch {
                if firstError == nil { firstError = error.localizedDescription }
            }
        }

        onImport(layers)
        if let firstError {
            onMessage("ERRO ao copiar: \(firstError)")
        } else if layers.isEmpty && skipped > 0 {
            onMessage("\(skipped) arquivo(s) de formato ainda não tratado")
        } else {
            onMessage("\(layers.count) mídia(s) importada(s)")
        }
    }
}
