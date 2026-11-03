import Foundation

enum EffectPresetTransfer {
    static func export(_ preset: EffectPreset) throws -> Data {
        try preset.validate()

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        return try encoder.encode(preset)
    }

    static func `import`(_ data: Data) throws -> EffectPreset {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let preset = try decoder.decode(EffectPreset.self, from: data)
        try preset.validate()
        return preset
    }

    static func save(
        _ preset: EffectPreset,
        to url: URL
    ) throws {
        let data = try export(preset)
        try data.write(to: url, options: .atomic)
    }
}
