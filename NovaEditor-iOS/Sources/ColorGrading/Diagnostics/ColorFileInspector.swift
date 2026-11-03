import Foundation

struct ColorFileInspector {
    enum Kind: String {
        case cube, ffx, unsupported
    }

    func inspect(_ url: URL) -> Kind {
        switch url.pathExtension.lowercased() {
        case "cube": return .cube
        case "ffx": return .ffx
        default: return .unsupported
        }
    }

    func recommendation(for kind: Kind) -> String {
        switch kind {
        case .cube: return "LUT 3D: importação e aplicação disponíveis."
        case .ffx: return "Preset After Effects: análise disponível; conversão depende dos efeitos encontrados."
        case .unsupported: return "Formato ainda não suportado."
        }
    }
}
