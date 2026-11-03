import Foundation

struct ProjectValidationIssue: Identifiable {
    let id = UUID()
    let message: String
}

enum ProjectValidator {
    static func inspect(_ project: EditorProject) -> [ProjectValidationIssue] {
        var issues: [ProjectValidationIssue] = []

        if project.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            issues.append(.init(message: "O projeto precisa de um nome"))
        }

        if project.width <= 0 || project.height <= 0 {
            issues.append(.init(message: "Resolução inválida"))
        }

        if project.frameRate <= 0 || project.frameRate > 240 {
            issues.append(.init(message: "FPS fora do intervalo suportado"))
        }

        if project.duration <= 0 {
            issues.append(.init(message: "Duração inválida"))
        }

        for layer in project.layers {
            if layer.duration < 0 {
                issues.append(.init(message: "Duração negativa: \(layer.name)"))
            }

            if layer.startTime < 0 {
                issues.append(.init(message: "Início negativo: \(layer.name)"))
            }
        }

        return issues
    }
}
