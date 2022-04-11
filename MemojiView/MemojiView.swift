//
//  MemojiView.swift
//  MemojiView
//
//  Created by Emre Armagan on 10.04.22.
//

import UIKit

 public protocol MemojiViewDelegate: AnyObject {
     func didUpdateImage(image: UIImage, type: ImageType)
}

public class MemojiView: UIView {
    internal var imageView: CircularImageView = {
        let view = CircularImageView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     internal var textView: MemojiTextField = {
        let tv = MemojiTextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    @available(iOS 13.0, *)
    internal lazy var editImageView: CircularImageView = {
        let i = CircularImageView()
        i.isUserInteractionEnabled = false
        //TODO: Fallback image
        i.image = UIImage(systemName: "pencil")
        i.tintColor = .white
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    private var _imageInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) {
        didSet {
            imageView.imageInsets = _imageInsets
        }
    }
   
    //MARK: Properties
    public weak var delegate: MemojiViewDelegate?
 
    /// Flag indicting if there the view should be editable. If set to true the tapping would open the keyboard for the memoji input.
    public var isEditable: Bool = true {
        didSet {
            textView.isUserInteractionEnabled = self.isEditable
            if isEditable {
                layoutSubviews()
            }
        }
    }
    
    /// Padding around the actual image
    public var imageInsets: UIEdgeInsets {
        get { return self._imageInsets }
        set { self._imageInsets = newValue }
    }
    
    /// The image containing the memoji/emoji
    public var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    /// Flag indicting whether there should be a edit button.
    @available(iOS 13.0, *)
    public lazy var showEditButton: Bool = isEditable {
        didSet {
            editImageView.removeFromSuperview()
            layoutSubviews()
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            imageView.backgroundColor = tintColor.withAlphaComponent(0.2)
            if #available(iOS 13.0, *) {
                editImageView.backgroundColor = tintColor
            }
        }
    }
    
    public override var backgroundColor: UIColor? {
        didSet {
            imageView.backgroundColor = backgroundColor
        }
    }
    
    /// The maximum number of letter allowed for text inputs
    public var maxLetters: Int {
        get { return self.textView.maxLetters }
        set { self.textView.maxLetters = newValue }
    }
    
    /// Closure that will be executed if the image changed
    public var onChange: ((UIImage, ImageType) -> Void)?
    
    //MARK: Lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        
        if #available(iOS 13.0, *) {
            guard showEditButton else { return }
            self.addSubview(editImageView)
            //TODO: Position view according to size
            let size = CGSize(width: 30, height: 30)
            let rect = CGPoint(x: imageView.frame.width - size.width - 15, y: imageView.frame.height - (size.height))
            editImageView.frame = CGRect(origin: rect, size: size)
        }
    }
    
    //MARK: Functions
    private func commonInit() {
        backgroundColor = .clear
        
        self.addSubview(imageView)
        self.addSubview(textView)
        
        textView.emojiDelegate = self
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

//MARK: -MemojiTextFieldDelegate
extension MemojiView: MemojiTextFieldDelegate {
    func didUpdateEmoji(emoji: UIImage?, type: ImageType) {
        self.imageView.image = emoji
        
        guard let image = emoji else {return}
        self.delegate?.didUpdateImage(image: image, type: type)
        self.onChange?(image, type)
    }
}
