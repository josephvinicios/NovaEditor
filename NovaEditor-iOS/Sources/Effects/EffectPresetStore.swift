import Foundation

final class EffectPresetStore {
    static let shared = EffectPresetStore()

    private let filename = "NovaEffectPresets"

    private init() {}

    private var fileURL: URL {
        let base = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        return base.appendingPathComponent(filename)
            .appendingPathExtension("json")
    }

    func load() -> [EffectPreset] {
        guard let data = try? Data(contentsOf: fileURL),
              let presets = try? JSONDecoder().decode(
                [EffectPreset].self, from: data
              ) else {
            return []
        }
        return presets
    }

    func save(_ preset: EffectPreset) throws {
        try preset.validate()
        var presets = load()
        presets.removeAll { $0.id == preset.id }
        presets.append(preset)
        let data = try JSONEncoder().encode(presets)
        try data.write(to: fileURL, options: .atomic)
    }

    func delete(_ id: UUID) throws {
        let presets = load().filter { $0.id != id }
        let data = try JSONEncoder().encode(presets)
        try data.write(to: fileURL, options: .atomic)
    }
}
