//
//  SwiftUIExampleViewController.swift
//  MemojiView
//
//  Created by Emre Armagan on 05.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import MemojiView
import SwiftUI
import UIKit

class SwiftUIExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIContent()
    }

    private func setupSwiftUIContent() {
        let hostingController = UIHostingController(rootView: MemojiContentView())
        addChild(hostingController)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}
