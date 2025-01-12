//
//  MemojiContentView.swift
//  MemojiView
//
//  Created by Emre Armagan on 05.01.25.
//  Copyright © 2025 Emre Armagan. All rights reserved.
//

import MemojiView
import SwiftUI

struct MemojiContentView: View {
    @State private var displayedImage: UIImage?
    @State private var displayedType: MemojiImageType?
    @State private var isEditable: Bool = true

    var body: some View {
        VStack(spacing: 20) {
            Text("Memoji Editor").font(.headline)

            MemojiViewRepresentable(
                image: $displayedImage,
                memojiType: $displayedType,
                isEditable: $isEditable,
                maxLetters: 10,
                textColor: .blue
            ) { updatedImage, updatedType in
                print("Updated image: \(updatedImage?.description ?? "nil")")
                print("Updated type: \(updatedType)")
            }
            .frame(height: 200)
            .border(Color.gray, width: 1)

            Toggle("Enable Editing", isOn: $isEditable)
                .padding()

            if let image = displayedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
        }
        .padding()
    }
}

struct MemojiContentView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiContentView()
            .previewDevice("iPhone 14 Pro")
            .previewDisplayName("ContentView Preview")
    }
}
