import SwiftUI
import UniformTypeIdentifiers

struct MediaImportButton: View {
    var onImport: ([EditorLayer]) -> Void
    @State private var showingPicker = false

    var body: some View {
        Button("＋ Mídia") {
            showingPicker = true
        }
        .fileImporter(
            isPresented: $showingPicker,
            allowedContentTypes: [.movie, .image, .audio],
            allowsMultipleSelection: true
        ) { result in
            guard case .success(let urls) = result else { return }
            var layers: [EditorLayer] = []
            let manager = FileManager.default
            let folder = manager.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0].appendingPathComponent("NovaMedia")

            try? manager.createDirectory(
                at: folder,
                withIntermediateDirectories: true
            )

            for url in urls {
                let access = url.startAccessingSecurityScopedResource()
                defer {
                    if access { url.stopAccessingSecurityScopedResource() }
                }

                let destination = folder.appendingPathComponent(url.lastPathComponent)
                do {
                    if manager.fileExists(atPath: destination.path) {
                        try manager.removeItem(at: destination)
                    }
                    try manager.copyItem(at: url, to: destination)

                    let ext = url.pathExtension.lowercased()
                    let type: LayerType

                    if ["mp4", "mov", "m4v"].contains(ext) {
                        type = .video
                    } else if ["mp3", "m4a", "wav", "aac"].contains(ext) {
                        type = .audio
                    } else {
                        type = .image
                    }

                    layers.append(EditorLayer(
                        name: url.deletingPathExtension().lastPathComponent,
                        type: type,
                        source: destination.path
                    ))
                } catch {
                    continue
                }
            }
            onImport(layers)
        }
    }
}
