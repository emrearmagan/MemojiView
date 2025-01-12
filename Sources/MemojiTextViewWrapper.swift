//
//  MemojiTextViewWrapper.swift
//  MemojiView
//
//  Created by Emre Armagan on 01.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import UIKit

/// A wrapper for `MemojiTextView` to manage interaction and UI behavior.
/// - The wrapper ensures that no direct interaction with the text field happens (e.g., no context menus for copy, paste, cut).
/// - The wrapper also centralizes keyboard management by intercepting tap gestures and controlling the first responder state.
open class MemojiTextViewWrapper: UIView {
    // MARK: Properties

    let memojiTextView = MemojiTextView()

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
        guard !memojiTextView.isFirstResponder else {
            memojiTextView.resignFirstResponder()
            return
        }

        memojiTextView.becomeFirstResponder()
    }

    private func commonInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(tap)
        memojiTextView.isUserInteractionEnabled = false

        addSubview(memojiTextView)
        memojiTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            memojiTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            memojiTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            memojiTextView.topAnchor.constraint(equalTo: topAnchor),
            memojiTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
