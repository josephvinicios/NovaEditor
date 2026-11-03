import Foundation
import CoreImage

final class EffectImageCache {
    static let shared = EffectImageCache()

    private let cache = NSCache<NSString, CIImage>()

    private init() {
        cache.countLimit = 80
    }

    func image(for key: String) -> CIImage? {
        cache.object(forKey: key as NSString)
    }

    func insert(_ image: CIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func remove(_ key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    func clear() {
        cache.removeAllObjects()
    }
}
