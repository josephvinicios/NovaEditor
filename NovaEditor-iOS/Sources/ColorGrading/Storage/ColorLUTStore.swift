import Combine
import Foundation

@MainActor
final class ColorLUTStore: ObservableObject {
    @Published private(set) var items: [ColorLUT] = []
    private let folder: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        let base = FileManager.default.urls(for: .applicationSupportDirectory,
                                            in: .userDomainMask).first!
        folder = base.appendingPathComponent("NovaEditor/ColorLUTs", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        load()
    }

    func add(_ lut: ColorLUT) throws {
        guard lut.isValid else { throw LUTImportError.invalidHeader }
        items.removeAll { $0.name.caseInsensitiveCompare(lut.name) == .orderedSame }
        items.append(lut)
        try persist()
    }

    func remove(id: UUID) {
        items.removeAll { $0.id == id }
        try? persist()
    }

    private func load() {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: folder, includingPropertiesForKeys: nil) else { return }
        items = files.filter { $0.pathExtension == "json" }.compactMap {
            guard let data = try? Data(contentsOf: $0),
                  let lut = try? decoder.decode(ColorLUT.self, from: data),
                  lut.isValid else { return nil }
            return lut
        }
    }

    private func persist() throws {
        for lut in items {
            let data = try encoder.encode(lut)
            let safeName = lut.id.uuidString + ".json"
            try data.write(to: folder.appendingPathComponent(safeName), options: .atomic)
        }
    }
}
