import Foundation

enum ProjectStore {
    private static var folder: URL {
        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documents.appendingPathComponent("NovaEditorProjects")
    }

    private static func prepareFolder() throws {
        try FileManager.default.createDirectory(
            at: folder,
            withIntermediateDirectories: true
        )
    }

    static func save(_ project: EditorProject) throws {
        try prepareFolder()

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let data = try encoder.encode(project)
        let url = folder.appendingPathComponent(
            project.id.uuidString + ".nova"
        )

        try data.write(to: url, options: .atomic)
    }

    static func load(id: UUID) throws -> EditorProject {
        let url = folder.appendingPathComponent(
            id.uuidString + ".nova"
        )

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(
            EditorProject.self,
            from: data
        )
    }

    static func list() throws -> [EditorProject] {
        try prepareFolder()

        let files = try FileManager.default.contentsOfDirectory(
            at: folder,
            includingPropertiesForKeys: nil
        )

        return files
            .filter { $0.pathExtension == "nova" }
            .compactMap { url in
                guard let data = try? Data(contentsOf: url) else {
                    return nil
                }

                return try? JSONDecoder().decode(
                    EditorProject.self,
                    from: data
                )
            }
            .sorted { $0.modifiedAt > $1.modifiedAt }
    }

    static func delete(id: UUID) throws {
        let url = folder.appendingPathComponent(
            id.uuidString + ".nova"
        )

        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
}
