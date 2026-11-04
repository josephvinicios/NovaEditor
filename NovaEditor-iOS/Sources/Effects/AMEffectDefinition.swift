import Foundation

struct AMEffectParam: Identifiable {
    var id: String
    var kind: String
    var attributes: [String: String]
    var label: String { attributes["label"] ?? id }
    var defaultValue: String { attributes["default"] ?? "" }
    var minValue: Double? { attributes["min"].flatMap(Double.init) }
    var maxValue: Double? { attributes["max"].flatMap(Double.init) }
    var step: Double? { attributes["step"].flatMap(Double.init) }
}

struct AMEffectDefinition: Identifiable {
    var id = ""
    var name = ""
    var nameEn = ""
    var desc = ""
    var category = ""
    var tags: [String] = []
    var params: [AMEffectParam] = []
    var previewSets: [String: String] = [:]
    var shader = ""
}

final class AMEffectParser: NSObject, XMLParserDelegate {
    private var def = AMEffectDefinition()
    private var inParams = false
    private var inPreview = false
    private var inShader = false
    private var depth = 0

    static func parse(_ data: Data) -> AMEffectDefinition? {
        let handler = AMEffectParser()
        let parser = XMLParser(data: data)
        parser.delegate = handler
        guard parser.parse(), !handler.def.id.isEmpty else { return nil }
        return handler.def
    }

    func parser(_ parser: XMLParser, didStartElement name: String,
                namespaceURI: String?, qualifiedName: String?,
                attributes a: [String: String] = [:]) {
        switch name {
        case "effect":
            def.id = a["id"] ?? ""
            def.name = a["name"] ?? ""
            def.nameEn = a["name-en"] ?? ""
            def.desc = a["desc"] ?? ""
            def.category = a["category"] ?? ""
            def.tags = (a["tags"] ?? "").split(separator: ",").map { String($0) }
        case "params": inParams = true; depth = 0
        case "preview": inPreview = true
        case "shader": inShader = true
        default:
            if inParams {
                depth += 1
                if depth == 1 {
                    def.params.append(AMEffectParam(id: a["id"] ?? "", kind: name, attributes: a))
                }
            } else if inPreview, name == "set", let p = a["param"] {
                def.previewSets[p] = a["value"] ?? ""
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement name: String,
                namespaceURI: String?, qualifiedName: String?) {
        switch name {
        case "params": inParams = false
        case "preview": inPreview = false
        case "shader": inShader = false
        default: if inParams { depth -= 1 }
        }
    }

    func parser(_ parser: XMLParser, foundCDATA data: Data) {
        if inShader, let s = String(data: data, encoding: .utf8) { def.shader += s }
    }
}

enum AMEffectCatalog {
    static func loadAll() -> (defs: [AMEffectDefinition], failed: [String]) {
        let urls = Bundle.main.urls(forResourcesWithExtension: "xml", subdirectory: "effects") ?? []
        var defs: [AMEffectDefinition] = []
        var failed: [String] = []
        for url in urls.sorted(by: { $0.lastPathComponent < $1.lastPathComponent }) {
            if let data = try? Data(contentsOf: url), let d = AMEffectParser.parse(data) {
                defs.append(d)
            } else {
                failed.append(url.lastPathComponent)
            }
        }
        return (defs, failed)
    }
}
