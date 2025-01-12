//
//  MemojiViewRepresentable.swift
//  MemojiView
//
//  Created by Emre Armagan on 05.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import SwiftUI
import UIKit

import SwiftUI
import UIKit

/// A SwiftUI wrapper for the UIKit-based `MemojiView`.
/// This representable allows you to use the `MemojiView` in SwiftUI views,
/// with support for binding properties and handling updates via closures or delegates.
@available(iOS 13.0, *)
public struct MemojiViewRepresentable: UIViewRepresentable {
    // MARK: - Properties

    /// The currently displayed image in the `MemojiView`.
    @Binding public var image: UIImage?

    /// The type of the currently displayed image (e.g., memoji, emoji, or text).
    @Binding public var memojiType: MemojiImageType?

    /// A flag indicating whether the view should allow editing.
    @Binding public var isEditable: Bool

    /// The maximum number of characters allowed for text input in the `MemojiView`.
    public var maxLetters: Int

    /// The color of the input text in the `MemojiView`.
    public var textColor: UIColor?

    /// A closure that is called whenever the image or its type is updated.
    public var onChange: ((UIImage?, MemojiImageType) -> Void)?

    // MARK: Init

    /// Initializes a new instance of `MemojiViewRepresentable`.
    /// - Parameters:
    ///   - image: A binding to the image displayed in the `MemojiView`.
    ///   - memojiType: A binding to the type of the displayed image.
    ///   - isEditable: A flag to enable or disable text editing.
    ///   - maxLetters: The maximum number of characters allowed for text input.
    ///   - textColor: The color of the input text.
    ///   - onChange: A closure called when the image or its type is updated.
    public init(
        image: Binding<UIImage?>,
        memojiType: Binding<MemojiImageType?>,
        isEditable: Binding<Bool>,
        maxLetters: Int,
        textColor: UIColor? = nil,
        onChange: ((UIImage?, MemojiImageType) -> Void)? = nil
    ) {
        _image = image
        _memojiType = memojiType
        _isEditable = isEditable
        self.maxLetters = maxLetters
        self.textColor = textColor
        self.onChange = onChange
    }

    // MARK: - UIViewRepresentable

    public func makeUIView(context: Context) -> MemojiView {
        let memojiView = MemojiView()
        memojiView.delegate = context.coordinator
        memojiView.isEditable = isEditable
        memojiView.maxLetters = maxLetters
        memojiView.textColor = textColor
        return memojiView
    }

    public func updateUIView(_ uiView: MemojiView, context: Context) {
        uiView.image = image
        uiView.isEditable = isEditable
        uiView.maxLetters = maxLetters
        uiView.textColor = textColor
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    // MARK: - Coordinator

    public class Coordinator: NSObject, MemojiViewDelegate {
        public var parent: MemojiViewRepresentable

        public init(parent: MemojiViewRepresentable) {
            self.parent = parent
        }

        public func didUpdateImage(image: UIImage?, type: MemojiImageType) {
            DispatchQueue.main.async {
                self.parent.image = image
                self.parent.memojiType = type
                self.parent.onChange?(image, type)
            }
        }
    }
}
