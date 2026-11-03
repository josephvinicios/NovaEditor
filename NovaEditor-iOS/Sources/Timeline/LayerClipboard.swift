import Foundation

final class LayerClipboard {
    static let shared = LayerClipboard()
    private(set) var copiedLayers: [EditorLayer] = []

    private init() {}

    func copy(_ layers: [EditorLayer]) {
        copiedLayers = layers
    }

    func paste(
        into project: inout EditorProject,
        at time: Double
    ) -> [UUID] {
        guard let earliest = copiedLayers.map(\.startTime).min() else {
            return []
        }

        var inserted: [UUID] = []

        for layer in copiedLayers {
            var copy = LayerDuplicator.duplicate(
                layer,
                offset: time - earliest
            )
            copy.id = UUID()
            project.addLayer(copy)
            inserted.append(copy.id)
        }

        return inserted
    }
}
