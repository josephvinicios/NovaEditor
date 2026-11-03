import Foundation

struct ProjectTemplate: Identifiable {
    let id: String
    let name: String
    let description: String
    let settings: ProjectSettings

    func createProject(name customName: String? = nil) -> EditorProject {
        EditorProject(
            name: customName ?? name,
            width: settings.width,
            height: settings.height,
            frameRate: settings.frameRate,
            duration: settings.duration
        )
    }

    static let all: [ProjectTemplate] = [
        .init(
            id: "vertical",
            name: "Vídeo vertical",
            description: "Formato para vídeos curtos",
            settings: .init()
        ),
        .init(
            id: "landscape",
            name: "Paisagem Full HD",
            description: "Vídeo horizontal",
            settings: .init(
                width: 1920, height: 1080,
                frameRate: 30, duration: 60
            )
        ),
        .init(
            id: "square",
            name: "Quadrado",
            description: "Composição quadrada",
            settings: .init(
                width: 1080, height: 1080,
                frameRate: 30, duration: 30
            )
        )
    ]
}
