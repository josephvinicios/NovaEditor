import SwiftUI

struct EditorWorkspaceView: View {
    @State private var project = EditorProject(name: "Meu Projeto")
    @State private var currentTime = 0.0
    @State private var selectedLayer: UUID?
    @State private var status = "Projeto pronto"

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("NOVA EDITOR").font(.headline.bold())
                Spacer()
                Button("Salvar") { saveProject() }
            }
            .padding(.horizontal)

            ZStack {
                Color.black
                VStack {
                    Text("NOVA")
                        .font(.system(size: 42, weight: .black))
                    Text("PRÉ-VISUALIZAÇÃO")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .foregroundColor(.white)
            .aspectRatio(9 / 16, contentMode: .fit)
            .padding(.horizontal, 65)

            HStack {
                Button {
                    currentTime = max(0, currentTime - 1.0 / 30.0)
                } label: {
                    Image(systemName: "backward.end.fill")
                }
                Spacer()
                Text(String(format: "%.2f s", currentTime))
                    .monospacedDigit()
                Spacer()
                Button {
                    currentTime = min(project.duration, currentTime + 1.0 / 30.0)
                } label: {
                    Image(systemName: "forward.end.fill")
                }
            }
            .padding(.horizontal, 25)

            Slider(value: $currentTime, in: 0...project.duration)
                .padding(.horizontal)

            HStack {
                Button("＋ Texto") { addLayer(.text, "Texto") }
                Button("＋ Forma") { addLayer(.shape, "Forma") }
                Button("＋ Áudio") { addLayer(.audio, "Áudio") }
            }
            .buttonStyle(.bordered)
            .font(.caption)

            List(project.layers) { layer in
                Button {
                    selectedLayer = layer.id
                } label: {
                    HStack {
                        Text(layer.name)
                        Spacer()
                        if selectedLayer == layer.id {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                }
            }
            .listStyle(.plain)

            Text(status).font(.caption2)
        }
        .preferredColorScheme(.dark)
        .background(Color.black)
    }

    private func addLayer(_ type: LayerType, _ name: String) {
        let layer = EditorLayer(
            name: "\(name) \(project.layers.count + 1)",
            type: type
        )
        project.addLayer(layer)
        selectedLayer = layer.id
        status = "Camada adicionada"
    }

    private func saveProject() {
        do {
            try ProjectStore.save(project)
            status = "OK - Projeto salvo"
        } catch {
            status = "ERROR - Falha ao salvar"
        }
    }
}
