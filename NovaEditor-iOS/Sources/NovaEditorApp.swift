import SwiftUI

@main
struct NovaEditorApp: App {
    var body: some Scene {
        WindowGroup {
            EditorWorkspaceView()
        }
    }
}

struct EditorView: View {
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.07, blue: 0.10)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("NOVA EDITOR")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black)
                    .frame(height: 230)
                    .overlay {
                        Image(systemName: "play.rectangle")
                            .font(.system(size: 55))
                            .foregroundColor(.gray)
                    }

                HStack {
                    Label("Mídia", systemImage: "photo")
                    Spacer()
                    Label("Áudio", systemImage: "waveform")
                    Spacer()
                    Label("Texto", systemImage: "textformat")
                }
                .foregroundColor(.white)

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 100)
                    .overlay {
                        Text("TIMELINE")
                            .foregroundColor(.gray)
                    }

                Spacer()
            }
            .padding()
        }
    }
}
