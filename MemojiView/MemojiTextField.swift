//
//  MemojiTextField.swift
//  MemojiView
//
//  Created by Emre Armagan on 10.04.22.
//

import UIKit

 protocol MemojiTextFieldDelegate: AnyObject {
    func didUpdateEmoji(emoji: UIImage?, isMemoji: Bool)
}

/// MemojiTextField is responsible for the retrieving the actual memoji/emoji 
class MemojiTextField: UITextView, UITextViewDelegate {
    private let memojiPasteboard = UIPasteboard(name: UIPasteboard.Name(rawValue: "memojiPasteboard"), create: true)
    
    internal weak var emojiDelegate: MemojiTextFieldDelegate?
   
    //TODO: Opening the emoji keyboard causes some warning. 
    /// Opens the keyboard with the emoji field
    override var textInputMode: UITextInputMode? {
        .activeInputModes.first(where: { $0.primaryLanguage == "emoji" })
    }
    /// required for iOS 13. Return a non-nil to show the Emoji keyboard
    override var textInputContextIdentifier: String? { "" }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        comminInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        comminInit()
    }
    
    private func comminInit() {
        self.delegate = self
        self.backgroundColor = .clear
        self.tintColor = .clear
        self.textColor = .clear
        self.autocorrectionType = .no
        self.returnKeyType = .done
        //self.autocapitalizationType = .allCharacters
        /// Enabled Memojis for the keyboard
        self.allowsEditingTextAttributes = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.addGestureRecognizer(tap)
    }
    
    private var becomeFirstResponse = false
    @objc func didTapView() {
        becomeFirstResponse = !becomeFirstResponse
        guard becomeFirstResponse else {
            self.resignFirstResponder()
            return
        }

        self.becomeFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
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
        
        return textView.text.utf16.count + text.utf16.count <= 2
    }
    
    
    /// Did paste memoji
    override func paste(_ sender: Any?) {
        super.paste(sender)
        if let image = UIPasteboard.general.image {
            memojiPasteboard?.image = image
            self.text = ""
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = String()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = String()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard var text = textView.text, !text.isEmpty else {return}
        if let image = memojiPasteboard?.image {
            emojiDelegate?.didUpdateEmoji(emoji: image, isMemoji: true)
            memojiPasteboard?.image = nil
            textView.text = ""
            return
        }

        //add padding for single letter otherwise it does not fit properly and looks weird
        if text.count == 1 && !text.isSingleEmoji {
            text = " \(text) "
        }
        textView.textColor = .clear
        
        let image = text.toImage()
        emojiDelegate?.didUpdateEmoji(emoji: image, isMemoji: false)
    }
    
    /// Disables context menu options like: Copy, paste and search
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
}
