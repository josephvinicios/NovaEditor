import Foundation
import Combine

@MainActor
final class ProjectHistory: ObservableObject {
    @Published private(set) var canUndo = false
    @Published private(set) var canRedo = false

    private var undoStack: [Data] = []
    private var redoStack: [Data] = []
    private let limit = 60

    func checkpoint(_ project: EditorProject) {
        guard let data = try? JSONEncoder().encode(project) else { return }

        undoStack.append(data)
        if undoStack.count > limit {
            undoStack.removeFirst()
        }

        redoStack.removeAll()
        updateState()
    }

    func undo(current: EditorProject) -> EditorProject? {
        guard let previous = undoStack.popLast(),
              let currentData = try? JSONEncoder().encode(current),
              let restored = try? JSONDecoder().decode(
                EditorProject.self,
                from: previous
              ) else { return nil }

        redoStack.append(currentData)
        updateState()
        return restored
    }

    func redo(current: EditorProject) -> EditorProject? {
        guard let next = redoStack.popLast(),
              let currentData = try? JSONEncoder().encode(current),
              let restored = try? JSONDecoder().decode(
                EditorProject.self,
                from: next
              ) else { return nil }

        undoStack.append(currentData)
        updateState()
        return restored
    }

    private func updateState() {
        canUndo = !undoStack.isEmpty
        canRedo = !redoStack.isEmpty
    }
}
