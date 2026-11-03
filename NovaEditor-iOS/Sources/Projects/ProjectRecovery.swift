import Foundation

final class ProjectRecovery {
    static let shared = ProjectRecovery()
    private let manager = FileManager.default

    private init() {}

    private var recoveryURL: URL {
        let directory = manager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent(
            "NovaRecovery",
            isDirectory: true
        )
        try? manager.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )
        return directory
    }

    func checkpoint(_ project: EditorProject) throws {
        let data = try JSONEncoder().encode(project)
        let destination = recoveryURL
            .appendingPathComponent(project.id.uuidString)
            .appendingPathExtension("recovery")
        try data.write(to: destination, options: .atomic)
    }

    func recover(_ id: UUID) -> EditorProject? {
        let file = recoveryURL
            .appendingPathComponent(id.uuidString)
            .appendingPathExtension("recovery")

        guard let data = try? Data(contentsOf: file) else {
            return nil
        }
        return try? JSONDecoder().decode(EditorProject.self, from: data)
    }

    func clear(_ id: UUID) {
        let file = recoveryURL
            .appendingPathComponent(id.uuidString)
            .appendingPathExtension("recovery")
        try? manager.removeItem(at: file)
    }
}
