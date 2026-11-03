import Foundation

struct ColorImportService {
    private let parser = CubeLUTParser()

    func importLUT(from url: URL) throws -> ColorLUT {
        let accessed = url.startAccessingSecurityScopedResource()
        defer { if accessed { url.stopAccessingSecurityScopedResource() } }
        let data = try Data(contentsOf: url)
        return try parser.parse(data: data, fileName: url.lastPathComponent)
    }

    func inspectFFX(from url: URL) throws -> FFXInspection {
        let accessed = url.startAccessingSecurityScopedResource()
        defer { if accessed { url.stopAccessingSecurityScopedResource() } }
        let data = try Data(contentsOf: url)
        return FFXInspection.inspect(data: data, fileName: url.lastPathComponent)
    }
}
