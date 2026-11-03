import Foundation

enum NovaPluginKind: String, Codable, CaseIterable {
    case effect
    case transition
    case generator
    case utility
    case importExport
}

struct PluginManifest: Codable, Identifiable {
    let id: String
    let name: String
    let version: String
    let author: String
    let kind: NovaPluginKind
    let description: String
    var minimumNovaVersion: String = "1.0"
}

struct PluginParameter: Codable, Identifiable {
    let id: String
    let name: String
    var value: Double
    let minimum: Double
    let maximum: Double
}

struct InstalledPlugin: Codable, Identifiable {
    var id: String { manifest.id }
    let manifest: PluginManifest
    var enabled: Bool = true
    var parameters: [PluginParameter] = []
}

final class PluginRegistry {
    static let shared = PluginRegistry()

    private(set) var plugins: [String: InstalledPlugin] = [:]

    private init() {}

    var all: [InstalledPlugin] {
        plugins.values.sorted {
            $0.manifest.name.localizedCaseInsensitiveCompare(
                $1.manifest.name
            ) == .orderedAscending
        }
    }

    func register(_ plugin: InstalledPlugin) throws {
        let id = plugin.manifest.id.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !id.isEmpty else {
            throw PluginError.invalidIdentifier
        }

        guard plugins[id] == nil else {
            throw PluginError.alreadyInstalled
        }

        plugins[id] = plugin
    }

    func setEnabled(_ enabled: Bool, for id: String) {
        guard var plugin = plugins[id] else { return }
        plugin.enabled = enabled
        plugins[id] = plugin
    }

    func remove(_ id: String) {
        plugins.removeValue(forKey: id)
    }

    func enabledPlugins(of kind: NovaPluginKind) -> [InstalledPlugin] {
        all.filter {
            $0.enabled && $0.manifest.kind == kind
        }
    }
}

enum PluginError: Error {
    case invalidIdentifier
    case alreadyInstalled
}
