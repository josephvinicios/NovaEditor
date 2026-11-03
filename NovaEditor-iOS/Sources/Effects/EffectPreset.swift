import Foundation

struct EffectPreset: Codable, Identifiable {
    var id = UUID()
    var name: String
    var author: String = "NovaEditor"
    var version: Int = 1
    var effects: [EffectInstance]
    var createdAt = Date()
}

enum EffectPresetError: Error {
    case emptyName
    case emptyEffects
    case invalidVersion
}

extension EffectPreset {
    func validate() throws {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { throw EffectPresetError.emptyName }

        guard !effects.isEmpty else {
            throw EffectPresetError.emptyEffects
        }

        guard version > 0 else {
            throw EffectPresetError.invalidVersion
        }
    }
}
