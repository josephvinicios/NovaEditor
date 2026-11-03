import Foundation

struct EffectParameter: Codable, Identifiable {
    var id: String
    var name: String
    var value: Double
    var minimum: Double
    var maximum: Double

    mutating func setValue(_ newValue: Double) {
        value = min(max(newValue, minimum), maximum)
    }
}

struct EffectInstance: Codable, Identifiable {
    var id = UUID()
    var type: String
    var name: String
    var enabled = true
    var parameters: [EffectParameter] = []
}

struct EffectDefinition: Identifiable {
    let id: String
    let name: String
    let category: String
    let parameters: [EffectParameter]

    func createInstance() -> EffectInstance {
        EffectInstance(
            type: id,
            name: name,
            parameters: parameters
        )
    }
}

enum EffectCatalog {
    static let all: [EffectDefinition] = [
        EffectDefinition(
            id: "color",
            name: "Correção de cor",
            category: "Cor",
            parameters: [
                .init(id: "brightness", name: "Brilho",
                      value: 0, minimum: -1, maximum: 1),
                .init(id: "contrast", name: "Contraste",
                      value: 1, minimum: 0, maximum: 2),
                .init(id: "saturation", name: "Saturação",
                      value: 1, minimum: 0, maximum: 2)
            ]
        ),
        EffectDefinition(
            id: "blur",
            name: "Desfoque gaussiano",
            category: "Desfoque",
            parameters: [
                .init(id: "radius", name: "Intensidade",
                      value: 0, minimum: 0, maximum: 40)
            ]
        ),
        EffectDefinition(
            id: "sharpen",
            name: "Nitidez",
            category: "Detalhes",
            parameters: [
                .init(id: "amount", name: "Intensidade",
                      value: 0.4, minimum: 0, maximum: 2)
            ]
        ),
        EffectDefinition(
            id: "hue",
            name: "Matiz",
            category: "Cor",
            parameters: [
                .init(id: "angle", name: "Ângulo",
                      value: 0, minimum: -Double.pi,
                      maximum: Double.pi)
            ]
        )
    ]
}
