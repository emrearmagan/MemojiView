//
//  MemojiView.swift
//  MemojiView
//
//  Created by Emre Armagan on 10.04.22.
//

import UIKit

/// Delegate protocol for `MemojiView` to notify when the displayed image is updated.
public protocol MemojiViewDelegate: AnyObject {
    /// Called when the image in the `MemojiView` is updated.
    /// - Parameters:
    ///   - image: The updated image, which can be a memoji, emoji, or text-based image.
    ///   - type: The type of the updated image (`MemojiImageType`).
    func didUpdateImage(image: UIImage?, type: MemojiImageType)
}

/// A customizable view that displays an emoji, memoji, or text converted to an image.
/// - Supports editable text input with `MemojiTextView`.
/// - Displays updates via an `UIImageView`.
open class MemojiView: UIView, MemojiTextViewDelegate {
    // MARK: Properties

    /// Delegate to notify when the image is updated.
    public weak var delegate: MemojiViewDelegate?

    /// Closure that will be executed if the image changed
    public var onChange: ((UIImage?, MemojiImageType) -> Void)?

    /// Flag indicating whether the view is editable. Enables or disables text input.
    public var isEditable: Bool = true {
        didSet {
            memojiView.isUserInteractionEnabled = isEditable
        }
    }

    /// The image containing the memoji/emoji
    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    /// The maximum number of characters allowed for input.
    public var maxLetters: Int {
        get { memojiView.memojiTextView.maxLetters }
        set { memojiView.memojiTextView.maxLetters = newValue }
    }

    /// The color of the input text.
    public var textColor: UIColor? {
        get { memojiView.memojiTextView.textColor }
        set { memojiView.memojiTextView.textColor = newValue }
    }

    /// ImageView to display the emoji, memoji, or text image.
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    /// Wrapper for `MemojiTextView` to manage input and interactions.
    private var memojiView = MemojiTextViewWrapper()

    // MARK: Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Methods

    private func commonInit() {
        backgroundColor = .clear
        memojiView.memojiTextView.emojiDelegate = self
        _setupUI()
    }

    private func _setupUI() {
        addSubview(memojiView)
        memojiView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            memojiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            memojiView.trailingAnchor.constraint(equalTo: trailingAnchor),
            memojiView.topAnchor.constraint(equalTo: topAnchor),
            memojiView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupUI()
    }

    /// Configures additional subviews and layout.
    /// - Override this method to customize the default behavior.
    open func setupUI() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }

    // MARK: - MemojiTextViewDelegate

    /// Called when the emoji or image is updated.
    /// - Override to customize behavior.
    /// - Parameters:
    ///   - emoji: The updated image, or `nil` if no valid image exists.
    ///   - type: The type of the updated image (`MemojiImageType`).
    open func emojiChanged(emoji: UIImage?, type: MemojiImageType) {
        image = emoji
        delegate?.didUpdateImage(image: image, type: type)
        onChange?(image, type)
    }
}
