import Foundation

struct FFXInspection: Identifiable {
    let id = UUID()
    let fileName: String
    let byteCount: Int
    let detectedText: [String]
    let status: Status

    enum Status {
        case recognizedContainer
        case unknownStructure
        case empty
    }

    static func inspect(data: Data, fileName: String) -> FFXInspection {
        let printable = data.map { byte -> Character in
            (byte >= 32 && byte <= 126) ? Character(UnicodeScalar(byte)) : " "
        }
        let text = String(printable)
        let tokens = text
            .components(separatedBy: CharacterSet(charactersIn: "\n\r\t "))
            .filter { $0.count >= 4 }
        let unique = Array(NSOrderedSet(array: tokens)) as? [String] ?? []
        let status: Status = data.isEmpty ? .empty :
            (unique.isEmpty ? .unknownStructure : .recognizedContainer)

        return FFXInspection(fileName: fileName, byteCount: data.count,
                             detectedText: Array(unique.prefix(80)), status: status)
    }

    var explanation: String {
        switch status {
        case .recognizedContainer:
            return "Arquivo analisado. Os textos encontrados são pistas, não uma conversão de efeitos."
        case .unknownStructure:
            return "Estrutura binária não reconhecida. Conversão automática ainda não disponível."
        case .empty:
            return "Arquivo vazio."
        }
    }
}
