import SwiftUI
import AVKit
import UIKit

private final class PipelineBox {
    var pipeline = LayerEffectPipeline()
}

struct MediaPreviewView: View {
    let layer: EditorLayer?
    let transform: LayerTransform
    var effects: [EffectInstance] = []
    @State private var player: AVPlayer?
    @State private var box = PipelineBox()

    var body: some View {
        ZStack {
            Color.black

            if let layer, let path = layer.source {
                switch layer.type {
                case .image:
                    if let image = UIImage(contentsOfFile: path) {
                        Image(uiImage: box.pipeline.render(
                            image: image,
                            layerID: layer.id,
                            effects: effects
                        ))
                        .resizable()
                        .scaledToFit()
                    } else {
                        placeholder("Imagem indisponível")
                    }

                case .video:
                    if let player {
                        VideoPlayer(player: player)
                    } else {
                        placeholder("Carregando vídeo...")
                    }

                case .audio:
                    placeholder("ÁUDIO")

                default:
                    placeholder(layer.name)
                }
            } else {
                placeholder("NOVA")
            }
        }
        .offset(x: transform.x, y: transform.y)
        .scaleEffect(x: transform.scaleX, y: transform.scaleY)
        .rotationEffect(.degrees(transform.rotation))
        .opacity(transform.opacity)
        .onAppear { loadVideo() }
        .onChange(of: layer?.source) { _ in loadVideo() }
    }

    private func loadVideo() {
        player?.pause()
        player = nil

        guard let layer,
              layer.type == .video,
              let path = layer.source else { return }

        let url = URL(fileURLWithPath: path)
        guard FileManager.default.fileExists(atPath: path) else { return }
        player = AVPlayer(url: url)
    }

    private func placeholder(_ text: String) -> some View {
        VStack {
            Text(text)
                .font(.system(size: 30, weight: .black))
                .foregroundColor(.white)
        }
    }
}
