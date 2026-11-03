import Foundation

enum LUTImportError: LocalizedError {
    case unreadableFile
    case invalidHeader
    case invalidDimension
    case invalidDomain
    case invalidValues(expected: Int, actual: Int)
    case unsupportedFormat

    var errorDescription: String? {
        switch self {
        case .unreadableFile: return "Não foi possível ler o arquivo."
        case .invalidHeader: return "Cabeçalho LUT inválido."
        case .invalidDimension: return "Dimensão LUT fora do intervalo suportado."
        case .invalidDomain: return "Intervalo DOMAIN_MIN/MAX inválido."
        case .invalidValues(let expected, let actual):
            return "Quantidade de valores inválida: esperado \(expected), recebido \(actual)."
        case .unsupportedFormat: return "Formato não suportado."
        }
    }
}
