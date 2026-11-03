import Foundation

enum ProjectDuplicator {
    static func duplicate(
        _ project: EditorProject,
        name: String
    ) -> EditorProject {
        var copy = project
        copy.id = UUID()
        copy.name = name
        copy.createdAt = Date()
        copy.modifiedAt = Date()

        copy.layers = project.layers.map { layer in
            var newLayer = layer
            newLayer.id = UUID()
            return newLayer
        }

        return copy
    }
}
