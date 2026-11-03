import Foundation

struct LayerSelection {
    private(set) var selectedIDs: Set<UUID> = []

    var isEmpty: Bool { selectedIDs.isEmpty }
    var count: Int { selectedIDs.count }

    mutating func select(_ id: UUID) {
        selectedIDs = [id]
    }

    mutating func toggle(_ id: UUID) {
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
    }

    mutating func selectAll(_ layers: [EditorLayer]) {
        selectedIDs = Set(layers.map(\.id))
    }

    mutating func clear() {
        selectedIDs.removeAll()
    }

    func selected(in layers: [EditorLayer]) -> [EditorLayer] {
        layers.filter { selectedIDs.contains($0.id) }
    }
}
