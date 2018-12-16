import UIKit

enum Metrics {
    static let spacing = 8 as CGFloat
    static let margin = 16 as CGFloat
    static let normal = 20 as CGFloat
    static let large = 32 as CGFloat

    enum Device {
        static var height: CGFloat {
            return UIScreen.main.bounds.height
        }

        static var width: CGFloat {
            return UIScreen.main.bounds.width
        }
    }

    enum FontSize {
        static let title = 32 as CGFloat
        static let body = 20 as CGFloat
    }
}
