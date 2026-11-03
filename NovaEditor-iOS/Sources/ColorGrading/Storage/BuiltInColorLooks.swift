import Foundation

enum BuiltInColorLooks {
    static let presets: [(name: String, settings: ColorGradeSettings)] = [
        ("Natural", ColorGradeSettings()),
        ("Cinematic", ColorGradeSettings(intensity: 1, exposure: -0.15,
                                          contrast: 1.18, saturation: 0.92)),
        ("Vibrant", ColorGradeSettings(intensity: 1, contrast: 1.08,
                                        saturation: 1.28)),
        ("Soft", ColorGradeSettings(intensity: 1, exposure: 0.12,
                                     contrast: 0.92, saturation: 0.9)),
        ("Warm", ColorGradeSettings(intensity: 1, saturation: 1.06,
                                     temperature: 18)),
        ("Cool", ColorGradeSettings(intensity: 1, contrast: 1.04,
                                     temperature: -18))
    ]
}
