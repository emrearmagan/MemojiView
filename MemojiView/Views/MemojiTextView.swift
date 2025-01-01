//
//  MemojiTextView.swift
//  MemojiView
//
//  Created by Emre Armagan on 10.04.22.
//

import UIKit

/// The delegate protocol for `MemojiTextView`
/// This allows communication between the text field and its parent components regarding changes or updates in the selected content.
protocol MemojiTextViewDelegate: AnyObject {
    /// Called whenever the text field updates its displayed content.
    /// - Parameters:
    ///   - emoji: The resulting image, which could represent a memoji, emoji, or a text-to-image conversion.
    ///   - type: The type of the resulting image (memoji, emoji, or text-based).
    func emojiChanged(emoji: UIImage?, type: MemojiImageType)
}

/// A custom UITextView subclass for handling memojis, emojis, and text-to-image conversions.
/// - Features:
///   - Opens an emoji keyboard by default.
///   - Converts text or emojis into images.
///   - Supports a maximum number of characters for text input.
///   - Communicates updates through a delegate.
class MemojiTextView: UITextView {
    /// Delegate to notify about updates in the text field.
    weak var emojiDelegate: MemojiTextViewDelegate?

    /// Maximum number of characters allowed in the text field.
    var maxLetters: Int = 2

    // TODO: Emits warnings on iOS 13 when opening the emoji keyboard.
    /// Opens the emoji keyboard when the text field becomes active.
    override public var textInputMode: UITextInputMode? {
        if let emojiKeyboard = UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == "emoji" }) {
            return emojiKeyboard
        }

        return super.textInputMode
    }

    /// Required for iOS 13 to show the emoji keyboard. Returns a non-nil identifier.
    override var textInputContextIdentifier: String? { "" }

    /// Overrides the text color, keeping the displayed text invisible.
    override var textColor: UIColor? {
        get { super.textColor }
        set {
            super.textColor = .clear
            if let newValue, newValue != .clear {
                _textColor = newValue
            }
        }
    }

    /// Stores the color used for rendering the text or emojis.
    private var _textColor: UIColor = .white

    /// Custom pasteboard for handling memoji images in <iOS18
    private let memojiPasteboard = UIPasteboard(name: UIPasteboard.Name(rawValue: "memojiPasteboard"), create: true)

    /// Flag to prevent recursive calls during internal updates.
    private var isInternalUpdate = false

    // MARK: Init

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        comminInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        comminInit()
    }

    // MARK: Methods

    private func comminInit() {
        delegate = self
        textColor = .clear
        backgroundColor = .clear
        tintColor = .clear
        autocorrectionType = .no
        returnKeyType = .done

        /// Enabled Memojis for the keyboard
        allowsEditingTextAttributes = true
        if #available(iOS 18.0, *) {
            supportsAdaptiveImageGlyph = true
        }

        if #available(iOS 14.0, *) {
            addDoneToolbar()
        }
    }

    @available(iOS 14.0, *)
    private func addDoneToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]

        inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() {
        resignFirstResponder()
    }

    /// Will be called once an memoji has been selected. Which results in paste
    override func paste(_ sender: Any?) {
        super.paste(sender)
        if let image = UIPasteboard.general.image {
            memojiPasteboard?.image = image
            text = ""
        }
    }

    /// Extracts a memoji image from attributed text, specifically for iOS 18 and later.
    /// See: https://mszpro.com/memoji-textfield-picking
    ///
    /// - Parameter attributedText: The attributed text containing the memoji.
    /// - Returns: The extracted memoji image, if available.
    private func getMemoji(in attributedText: NSAttributedString?) -> UIImage? {
        if #available(iOS 18, *) {
            guard let attachment = findFirstAttachment(in: attributedText) else {
                return nil
            }

            if let image = attachment.image {
                return image
            } else if let image = attachment.image(forBounds: attachment.bounds,
                                                   textContainer: nil,
                                                   characterIndex: 0) {
                return image
            } else if let imageData = attachment.fileWrapper?.regularFileContents,
                      let image = UIImage(data: imageData) {
                return image
            }

            return nil
        }

        return memojiPasteboard?.image
    }

    /// Disables context menu options like: Copy, paste and search
    override func caretRect(for _: UITextPosition) -> CGRect {
        return CGRect.zero
    }

    /// Disables selection rectangles for the text field.
    override func selectionRects(for _: UITextRange) -> [UITextSelectionRect] {
        return []
    }
}

// MARK: Helper

extension MemojiTextView {
    /// Finds the first attachment in the attributed text, including adaptive image glyphs for iOS 18.
    /// - Parameter attributedText: The attributed text to search.
    /// - Returns: The first `NSTextAttachment` found, or `nil`.
    @available(iOS 18, *)
    private func findFirstAttachment(in attributedText: NSAttributedString?) -> NSTextAttachment? {
        guard let attributedText else { return nil }

        // First try to find NSAdaptiveImageGlyph
        var foundGlyph: NSTextAttachment?
        attributedText.enumerateAttribute(.adaptiveImageGlyph,
                                          in: NSRange(location: 0, length: attributedText.length),
                                          options: []) { value, _, stop in
            if let glyph = value as? NSAdaptiveImageGlyph {
                let attachment = NSTextAttachment()
                attachment.image = UIImage(data: glyph.imageContent)
                foundGlyph = attachment
                stop.pointee = true
            }
        }

        if let foundGlyph { return foundGlyph }

        // Fallback to regular attachment
        var foundAttachment: NSTextAttachment?
        attributedText.enumerateAttribute(.attachment,
                                          in: NSRange(location: 0, length: attributedText.length),
                                          options: []) { value, _, stop in
            if let attachment = value as? NSTextAttachment {
                foundAttachment = attachment
                stop.pointee = true
            }
        }
        return foundAttachment
    }
}

// MARK: - UITextFieldDelegate

extension MemojiTextView: UITextViewDelegate {
    /// Validates and processes text input changes.
    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        if text.isSingleEmoji {
            guard textView.text == text else {
                textView.text = ""
                return true
            }
            return false
        }

        if textView.text.isSingleEmoji {
            textView.text = ""
        }

        return textView.text.utf16.count + text.utf16.count <= maxLetters
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = String()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = String()
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        // Skip processing if this is an internal update
        if isInternalUpdate { return }

        guard var text = textView.text, !text.isEmpty else {
            emojiDelegate?.emojiChanged(emoji: nil, type: .text(count: 0, value: ""))
            return
        }

        if let memoji = getMemoji(in: textView.attributedText) {
            emojiDelegate?.emojiChanged(emoji: memoji, type: .memoji)
            memojiPasteboard?.image = nil

            // memojies in iOS18 come as an attributedText and dont work with the pasteboard anymore.
            // But this causes an string with a space (" ").
            // Clearing the Textfield causes calls the delegate again and removes the image in the previous guard. Therefore, we use the `isInternalUpdate` flag.
            isInternalUpdate = true
            textView.text = ""
            isInternalUpdate = false
            return
        }

        let counter = text.count
        let isSingleEmoji = text.isSingleEmoji

        // add padding for smaller letters otherwise it does not fit properly and looks weird
        if counter < maxLetters, !isSingleEmoji {
            let missingLetters = maxLetters - counter
            let padding = String(repeating: " ", count: (missingLetters + 1) / 2)
            text = padding + text + padding
        }

        let image = text.toImage(color: _textColor)
        let type = isSingleEmoji ? MemojiImageType.emoji : .text(count: counter, value: text)
        emojiDelegate?.emojiChanged(emoji: image, type: type)

        isInternalUpdate = true
        textView.text = ""
        isInternalUpdate = false
    }
}
