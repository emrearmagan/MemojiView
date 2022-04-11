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
    
    //TODO: Currently the default size is 98. Anything above causes the image not suitable for Widgets since the size will be too large.
    /// Converts the string to an image.
    func toImage(size: CGFloat = 98) -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: size) // you can change your font size here
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context
        
        return image ?? UIImage()
    }

}
