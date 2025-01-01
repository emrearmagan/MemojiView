//
//  String.swift
//  MemojiView
//
//  Created by Emre Armagan on 10.04.22.
//

import UIKit

extension String {
    /// Returns the if the String is a single emoji
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    /// Returns the if the String contains at least one emoji
    var containsEmoji: Bool { contains { $0.isEmoji } }

    /// Returns the if the String only contains emojis
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }

    // TODO: Currently the default size is 98. Anything above causes the image not suitable for Widgets since the size will be too large.
    /// Converts the string to a `UIImage` representation with a specified font size.
    /// The resulting image is sized to fit the string exactly, with the text rendered using the specified font size.
    ///
    /// - Parameter size: The font size to use when rendering the text. Default is 98.
    /// - Returns: A `UIImage` containing the rendered text, or `nil` if the rendering fails.
    func toImage(size: CGFloat = 98, color: UIColor = .white) -> UIImage? {
        let nsString = (self as NSString)

        let font = UIFont.systemFont(ofSize: size)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let textSize = nsString.size(withAttributes: attributes)

        let renderer = UIGraphicsImageRenderer(size: textSize)
        return renderer.image { context in
            // Set a clear background
            UIColor.clear.set()
            context.fill(CGRect(origin: .zero, size: textSize))
            nsString.draw(at: .zero, withAttributes: attributes)
        }
    }
}
