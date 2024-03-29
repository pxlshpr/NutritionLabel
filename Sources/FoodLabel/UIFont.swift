import Foundation
import UIKit

extension UIFont {
    func fontSize(for text: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: self]
        let size = (text as NSString).size(withAttributes: fontAttributes)
        return size
    }
}
