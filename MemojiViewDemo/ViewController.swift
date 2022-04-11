//
//  ViewController.swift
//  MemojiViewDemo
//
//  Created by Emre Armagan on 10.04.22.
//

import UIKit
import MemojiView

class ViewController: UIViewController, MemojiViewDelegate {
    let size = CGSize(width: 180, height: 180)
    static let color = UIColor(red: 156/255, green: 130/255, blue: 255/255, alpha: 1)
    static let defaultImage =  UIImage(named: "user.image")
    
    private let memojiView: MemojiView = {
        let view = MemojiView(frame: .zero)
        view.image = ViewController.defaultImage
        view.tintColor = ViewController.color
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
        
        memojiView.frame = CGRect(origin: CGPoint(x: self.view.center.x - (size.width / 2), y: 100), size: size) // use constraint in real project
        memojiView.delegate = self
        miniMemojiView.tintColor = ViewController.color
        memojiView.onChange = { image, imageType in
            self.miniMemojiView.image = image
        }
        
        self.view.addSubview(memojiView)
        setupView()
    }
    
    func didUpdateImage(image: UIImage, type: ImageType) {
        // Set padding depending on image type for a more pleasant look
        let padding: CGFloat = (type == .memoji) ? 5 : 35
        memojiView.imageInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}

//MARK: -UI
extension ViewController {
    private func setupView() {
        // Adding some content to view for demonstration purposes
        let rect = CGRect(origin: CGPoint(x: 0, y: 100 + size.height + 18), size: .init(width: self.view.frame.width, height: 30))
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
        icons.enumerated().forEach {
            let image = UIImage(systemName: $0.1)
            let imageview = UIImageView()
            imageview.image = image
            imageview.tintColor = $0.0 == 0 ? .systemBlue : .lightGray
            stackView.addArrangedSubview(imageview)
        }
        
        // ------
        let descriptionStack = UIStackView(frame: stackView.frame.inset(by: .init(top: 50, left: 0, bottom: -120, right: 0)))
        descriptionStack.axis = .vertical
        descriptionStack.distribution = .fillEqually
        let dict = ["📍": "Lives in Germany", "💼": "Work as Developer at Apple Inc.", "🚀": "Goal is learn SwiftUI"]
        dict.reversed().forEach {
            let label = UILabel()
            label.text = "\($0.key)  \($0.value)"
            label.font = .AvenirNext.regular(size: 16)
            descriptionStack.addArrangedSubview(label)
        }
        
        let rectView = CGRect(origin: CGPoint(x: descriptionStack.center.x - 100, y: descriptionStack.frame.maxY + 30), size: CGSize(width: 200, height: 200))
        let view = UIView(frame: rectView)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5.0
        
        miniMemojiView.frame = CGRect(origin: CGPoint(x: 50, y: 50), size: CGSize(width: 100, height: 100))
        view.addSubview(miniMemojiView)
        

        self.view.addSubview(nameLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(stackView)
        self.view.addSubview(descriptionStack)
        self.view.addSubview(view)
    }
}

//MARK: -Font
extension UIFont {
    struct AvenirNext {
        static func regular(size: CGFloat) -> UIFont {
            return UIFont(name: "AvenirNext-Regular", size: size)!
        }
    
        static func medium(size: CGFloat)-> UIFont {
            return UIFont(name: "AvenirNext-Medium", size: size)!
        }
        
        static func bold(size: CGFloat)-> UIFont {
            return UIFont(name: "AvenirNext-Bold", size: size)!
        }
    }
}
