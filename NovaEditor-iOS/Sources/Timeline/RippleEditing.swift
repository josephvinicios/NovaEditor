import Foundation

enum RippleEditing {
    static func remove(
        layerID: UUID,
        from project: inout EditorProject,
        ripple: Bool
    ) {
        guard let removed = project.layers.first(where: {
            $0.id == layerID
        }) else { return }

        project.removeLayer(id: layerID)

        guard ripple else { return }

        let cutEnd = removed.startTime + removed.duration

        for index in project.layers.indices {
            if project.layers[index].startTime >= cutEnd {
                project.layers[index].startTime = max(
                    0,
                    project.layers[index].startTime - removed.duration
                )
            }
        }

        project.modifiedAt = Date()
    }

    static func closeGap(
        after time: Double,
        duration: Double,
        in project: inout EditorProject
    ) {
        let end = time + max(0, duration)

        for index in project.layers.indices {
            if project.layers[index].startTime >= end {
                project.layers[index].startTime -= duration
            }
        }

        project.modifiedAt = Date()
    }
}
