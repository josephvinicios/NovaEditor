import Foundation

final class EffectStackStore {
    static let shared = EffectStackStore()
    private let key = "NovaEditor.EffectStacks.v1"

    private var stacks: [String: [EffectInstance]] = [:]

    private init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode(
                [String: [EffectInstance]].self,
                from: data
           ) {
            stacks = saved
        }
    }

    func effects(for layerID: UUID) -> [EffectInstance] {
        stacks[layerID.uuidString] ?? []
    }

    func save(_ effects: [EffectInstance], for layerID: UUID) {
        stacks[layerID.uuidString] = effects
        persist()
    }

    func add(_ effect: EffectInstance, to layerID: UUID) {
        var current = effects(for: layerID)
        current.append(effect)
        save(current, for: layerID)
    }

    func remove(_ effectID: UUID, from layerID: UUID) {
        var current = effects(for: layerID)
        current.removeAll { $0.id == effectID }
        save(current, for: layerID)
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(stacks) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
