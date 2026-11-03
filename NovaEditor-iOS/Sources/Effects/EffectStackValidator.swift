import Foundation

struct EffectStackIssue: Identifiable {
    let id = UUID()
    let message: String
}

enum EffectStackValidator {
    static func inspect(_ effects: [EffectInstance]) -> [EffectStackIssue] {
        var issues: [EffectStackIssue] = []
        var identifiers = Set<UUID>()

        for effect in effects {
            if !identifiers.insert(effect.id).inserted {
                issues.append(.init(message: "Efeito duplicado: \(effect.name)"))
            }

            if effect.type.isEmpty {
                issues.append(.init(message: "Efeito sem identificador"))
            }

            for parameter in effect.parameters {
                if parameter.minimum > parameter.maximum {
                    issues.append(.init(
                        message: "Intervalo inválido: \(parameter.name)"
                    ))
                }

                if !parameter.value.isFinite {
                    issues.append(.init(
                        message: "Valor inválido: \(parameter.name)"
                    ))
                }
            }
        }

        return issues
    }
}
