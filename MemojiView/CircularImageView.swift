//
//  CircularImageView.swift
//  MemojiView
//
//  Created by Emre Armagan on 10.04.22.
//

import UIKit

internal class CircularImageView: UIView {
    //MARK: Properties
    internal var imageView = UIImageView()
    
    internal var imageConstraints: [NSLayoutConstraint] = []
    
    /// The image for the imageView
    internal var image: UIImage? { didSet { layoutView() } }
    
    /// Insets around the image
    internal var imageInsets: UIEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6) {didSet {layoutView() } }
    
    override var tintColor: UIColor! {
        didSet {
            self.imageView.tintColor = tintColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
    private func setupView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        layoutView()
    }
    
    
    private func layoutView() {
        guard let image = image else {return}
        NSLayoutConstraint.deactivate(imageConstraints)
        
        imageConstraints = [
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: imageInsets.left),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -imageInsets.right),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: imageInsets.top),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -imageInsets.bottom)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
        imageView.image = image
    }
}
