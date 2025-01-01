//
//  MemojiImageType.swift
//  MemojiView
//
//  Created by Emre Armagan on 01.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import Foundation

/// Enum representing the types of images that can be produced by the `MemojiTextView`.
public enum MemojiImageType: Equatable {
    /// - `memoji`: Represents a memoji image.
    case memoji
    /// - `emoji`: Represents a single emoji.
    case emoji
    /// Represents an image created from text.
    /// - Parameters:
    ///   - count: The number of characters in the text.
    ///   - value: The actual text value used to generate the image.
    case text(count: Int, value: String)
}
