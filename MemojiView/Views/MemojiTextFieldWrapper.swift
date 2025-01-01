//
//  MemojiTextFieldWrapper.swift
//  MemojiView
//
//  Created by Emre Armagan on 01.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// A wrapper for `MemojiTextField` to manage interaction and UI behavior.
/// - The wrapper ensures that no direct interaction with the text field happens (e.g., no context menus for copy, paste, cut).
/// - The wrapper also centralizes keyboard management by intercepting tap gestures and controlling the first responder state.
open class MemojiTextFieldWrapper: UIView {
    // MARK: Properties

    let memojiTextField = MemojiTextField()

    // MARK: Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: Methods

    @objc func didTapView() {
        guard !memojiTextField.isFirstResponder else {
            memojiTextField.resignFirstResponder()
            return
        }

        memojiTextField.becomeFirstResponder()
    }

    private func commonInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(tap)
        memojiTextField.isUserInteractionEnabled = false

        addSubview(memojiTextField)
        memojiTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            memojiTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            memojiTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            memojiTextField.topAnchor.constraint(equalTo: topAnchor),
            memojiTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
