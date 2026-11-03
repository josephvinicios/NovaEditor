import Foundation

final class PluginPackageStore {
    static let shared = PluginPackageStore()

    private init() {}

    private var pluginsDirectory: URL {
        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documents.appendingPathComponent(
            "NovaPlugins",
            isDirectory: true
        )
    }

    func loadPackages() throws -> Int {
        let manager = FileManager.default

        try manager.createDirectory(
            at: pluginsDirectory,
            withIntermediateDirectories: true
        )

        let folders = try manager.contentsOfDirectory(
            at: pluginsDirectory,
            includingPropertiesForKeys: [.isDirectoryKey]
        )

        var loaded = 0

        for folder in folders {
            let manifestURL = folder.appendingPathComponent("manifest.json")

            guard manager.fileExists(atPath: manifestURL.path),
                  let data = try? Data(contentsOf: manifestURL),
                  let manifest = try? JSONDecoder().decode(
                    PluginManifest.self,
                    from: data
                  ) else {
                continue
            }

            let plugin = InstalledPlugin(manifest: manifest)

            do {
                try PluginRegistry.shared.register(plugin)
                loaded += 1
            } catch {
                continue
            }
        }

        return loaded
    }
}
