import Foundation

enum EffectSearch {
    static func filter(
        _ effects: [EffectDefinition],
        query: String,
        category: String? = nil
    ) -> [EffectDefinition] {
        let term = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return effects.filter { effect in
            let matchesQuery = term.isEmpty ||
                effect.name.localizedCaseInsensitiveContains(term) ||
                effect.id.localizedCaseInsensitiveContains(term) ||
                effect.category.localizedCaseInsensitiveContains(term)

            let matchesCategory = category == nil ||
                effect.category == category

            return matchesQuery && matchesCategory
        }
    }

    static var categories: [String] {
        Array(Set(EffectCatalog.all.map { $0.category })).sorted()
    }
}
