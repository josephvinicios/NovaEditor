import Foundation

struct LayerGroup: Codable, Identifiable {
    var id = UUID()
    var name: String
    var layerIDs: [UUID]
    var enabled = true
}

enum LayerGrouping {
    static func makeGroup(
        name: String,
        layers: [EditorLayer]
    ) -> LayerGroup {
        LayerGroup(name: name, layerIDs: layers.map(\.id))
    }

    static func members(
        of group: LayerGroup,
        in layers: [EditorLayer]
    ) -> [EditorLayer] {
        layers.filter { group.layerIDs.contains($0.id) }
    }
}
