import SwiftUI

struct EditorWorkspaceView: View {
    @State private var project = EditorProject(name: "Meu Projeto")
    @StateObject private var playback = TimelinePlayback()
    private var currentTime: Double { playback.currentTime }
    @State private var selectedLayer: UUID?
    @State private var status = "Projeto pronto"
    @State private var showingEffects = false
    @State private var effectsRevision = 0

    private var selectedLayerBinding: Binding<EditorLayer>? {
        guard let id = selectedLayer,
              let index = project.layers.firstIndex(where: { $0.id == id })
        else { return nil }

        return Binding(
            get: { project.layers[index] },
            set: { project.layers[index] = $0 }
        )
    }

    private var previewTransform: LayerTransform {
        guard let layer = project.layers.first(where: {
            $0.id == selectedLayer
        }) else { return LayerTransform() }

        let engine = TimelineEngine(currentTime: playback.currentTime)
        var result = layer.transform
        result.x = engine.value(for: "x", in: layer, default: result.x)
        result.y = engine.value(for: "y", in: layer, default: result.y)
        result.scaleX = engine.value(for: "scaleX", in: layer, default: result.scaleX)
        result.scaleY = engine.value(for: "scaleY", in: layer, default: result.scaleY)
        result.rotation = engine.value(for: "rotation", in: layer, default: result.rotation)
        result.opacity = engine.value(for: "opacity", in: layer, default: result.opacity)
        return result
    }

    private var previewEffects: [EffectInstance] {
        _ = effectsRevision
        guard let id = selectedLayer else { return [] }
        return EffectStackStore.shared.effects(for: id)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("NOVA EDITOR").font(.headline.bold())
                Spacer()
                Button("Salvar") { saveProject() }
            }
            .padding(.horizontal)

            MediaPreviewView(layer: project.layers.first { $0.id == selectedLayer }, transform: previewTransform, effects: previewEffects)
            .aspectRatio(9 / 16, contentMode: .fit)
            .padding(.horizontal, 65)

            HStack {
                Button {
                    playback.currentTime = max(0, currentTime - 1.0 / 30.0)
                } label: {
                    Image(systemName: "backward.end.fill")
                }
                Spacer()
                Text(String(format: "%.2f s", currentTime))
                    .monospacedDigit()
                Spacer()
                Button {
                    playback.currentTime = min(project.duration, currentTime + 1.0 / 30.0)
                } label: {
                    Image(systemName: "forward.end.fill")
                }
            }
            .padding(.horizontal, 25)

                TimelineRulerView(duration: project.duration, currentTime: playback.currentTime)
            Slider(value: $playback.currentTime, in: 0...project.duration)
                .padding(.horizontal)

            HStack {
                PlaybackControls(playback: playback)
                MediaImportButton { layers in
                    for layer in layers {
                        project.addLayer(layer)
                        selectedLayer = layer.id
                    }
                    status = layers.isEmpty ? "Nenhuma mídia importada" : "Mídia importada"
                }
                Button("＋ Texto") { addLayer(.text, "Texto") }
                Button("＋ Forma") { addLayer(.shape, "Forma") }
                Button("＋ Áudio") { addLayer(.audio, "Áudio") }
                Button("Efeitos") { showingEffects = true }
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

            if let binding = selectedLayerBinding {
                LayerPropertiesPanel(
                    layer: binding,
                    currentTime: currentTime
                )
            }

            Text(status).font(.caption2)
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingEffects, onDismiss: { effectsRevision += 1 }) {
            if let id = selectedLayer {
                EffectStackView(layerID: id)
                    .presentationDetents([.medium, .large])
            }
        }
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
