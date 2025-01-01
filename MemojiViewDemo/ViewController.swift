//
//  ViewController.swift
//  MemojiViewDemo
//
//  Created by Emre Armagan on 10.04.22.
//

import MemojiView
import UIKit

class ViewController: UIViewController, MemojiViewDelegate {
    let size = CGSize(width: 180, height: 180)
    static let color = UIColor(red: 156 / 255, green: 130 / 255, blue: 255 / 255, alpha: 1)
    static let defaultImage = UIImage(named: "user.image")

    private let memojiView: MemojiView = {
        let view = MemojiView(frame: .zero)
        view.image = ViewController.defaultImage
        view.backgroundColor = ViewController.color.withAlphaComponent(0.4)
        return view
    }()

    private let miniMemojiView: MemojiView = {
        let view = MemojiView(frame: .zero)
        view.image = ViewController.defaultImage
        view.backgroundColor = ViewController.color
        view.isEditable = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        memojiView.frame = CGRect(origin: CGPoint(x: view.center.x - (size.width / 2), y: 100), size: size)
        memojiView.layer.cornerRadius = size.height / 2
        memojiView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        memojiView.delegate = self
        memojiView.onChange = { [weak self] image, _ in
            self?.miniMemojiView.image = image
        }

        view.addSubview(memojiView)
        setupView()
    }

    func didUpdateImage(image _: UIImage?, type: MemojiImageType) {
        // Set padding depending on image type for a more pleasant look
        let padding: CGFloat = (type == .memoji) ? 15 : 35
        memojiView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}

// MARK: - UI

extension ViewController {
    private func setupView() {
        // Adding some content to view for demonstration purposes
        let rect = CGRect(origin: CGPoint(x: 0, y: 100 + size.height + 18), size: .init(width: view.frame.width, height: 30))
        let nameLabel = UILabel(frame: rect)
        let welcomeString = NSMutableAttributedString(string: "Welcome, ", attributes: [.font: UIFont.AvenirNext.regular(size: 20), .foregroundColor: UIColor.label])
        let nameString = NSMutableAttributedString(string: "Emre Armagan 👋", attributes: [NSAttributedString.Key.font: UIFont.AvenirNext.bold(size: 20), .foregroundColor: UIColor.label])
        welcomeString.append(nameString)

        nameLabel.textAlignment = .center
        nameLabel.attributedText = welcomeString

        let subtitleLabel = UILabel(frame: nameLabel.frame.inset(by: .init(top: 30, left: 0, bottom: -30, right: 0)))
        subtitleLabel.frame.size.height = 50
        subtitleLabel.text = "UI/UX Designer, Swift Developer\n and Coding enthusiast"
        subtitleLabel.font = .AvenirNext.medium(size: 16)
        subtitleLabel.textColor = .lightGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        // ------
        let stackView = UIStackView(frame: subtitleLabel.frame.inset(by: .init(top: 70, left: 40, bottom: -65, right: 40)))
        stackView.distribution = .fillEqually
        stackView.spacing = 40
        let icons = ["phone.circle.fill", "video.circle", "message.circle", "envelope.circle"]
        for icon in icons.enumerated() {
            let image = UIImage(systemName: icon.1)
            let imageview = UIImageView()
            imageview.image = image
            imageview.tintColor = icon.0 == 0 ? .systemBlue : .lightGray
            stackView.addArrangedSubview(imageview)
        }

        // ------
        let descriptionStack = UIStackView(frame: stackView.frame.inset(by: .init(top: 50, left: 0, bottom: -120, right: 0)))
        descriptionStack.axis = .vertical
        descriptionStack.distribution = .fillEqually
        let dict = ["📍": "Lives in Germany", "💼": "Work as Developer at Apple Inc.", "🚀": "Goal is to learn SwiftUI"]
        for item in dict.reversed() {
            let label = UILabel()
            label.text = "\(item.key)  \(item.value)"
            label.font = .AvenirNext.regular(size: 16)
            descriptionStack.addArrangedSubview(label)
        }

        let rectView = CGRect(origin: CGPoint(x: descriptionStack.center.x - 100, y: descriptionStack.frame.maxY + 30), size: CGSize(width: 200, height: 200))
        let containerView = UIView(frame: rectView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = .default

        miniMemojiView.frame = CGRect(origin: CGPoint(x: 50, y: 50), size: CGSize(width: 100, height: 100))
        miniMemojiView.layer.cornerRadius = 50
        containerView.addSubview(miniMemojiView)

        view.addSubview(nameLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(stackView)
        view.addSubview(descriptionStack)
        view.addSubview(containerView)
    }
}

// MARK: - Font

extension UIFont {
    enum AvenirNext {
        static func regular(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirNext-Regular", size: size)!
        }

        static func medium(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirNext-Medium", size: size)!
        }

        static func bold(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirNext-Bold", size: size)!
        }
    }
}

extension UIColor {
    public static var `default`: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 26/255, green: 29/255, blue: 33/255, alpha: 1.0)

                default:
                    return .white
            }
        }
    }
}
