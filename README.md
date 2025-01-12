## MemojiView

![Platform](https://img.shields.io/badge/platform-ios-lightgray.svg)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
![iOS 13.0+](https://img.shields.io/badge/iOS-12.0%2B-blue.svg)
![MIT](https://img.shields.io/github/license/mashape/apistatus.svg)

----
<div>
<br>
<div align="center">
<img src="./Example/Supporting Files/Preview/banner.png" alt="Banner" width=90%>
</div>

Since there is no official API for using the users Memoji's i have built a simple view to retrieve them and use them to your liking.

MemojiView works by having a TextView behind the actual View for user input. The passed string is converted to an image and displayed in the view.
That could also lead that users input character or emoji's with will also be converted to images.
Either conform to the delegate and display a warning if the users selects anything than a memoji or simply accepts any kind of input.

[📖 Documentation](https://emrearmagan.github.io/MemojiView/)

### Quick start
<br>
<div>
  <img width="30%" src="./Example/Supporting Files/Preview/preview1.png" alt="preview1">
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img width="30%" src="./Example/Supporting Files/Preview/preview2.png" alt="preview2">
</div>

###### MemojiView

```swift
let memojiView = MemojiView(frame: .zero)
memojiView.tintColor = .purple

self.view.addSubview(memojiView)   
```

###### Image types
MemojiView has 3 types of images.
- `memoji`: Is a single Memoji image.
- `emoji`: Is a single Emoji image.
- `text(Int)` : A string converted into an image, including the character count and the actual text

```swift
enum MemojiImageType: Equatable {
    case memoji
    case emoji
    case text(Int)
}
```

###### Delegate

To respond to changes of the image, implement the `MemojiViewDelegate` protocol in your class, e.g. a View Controller, and then set the views `delegate` property:

```swift
class MyViewController: UIViewController, MemojiViewDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()

    let memojiView = MemojiView(frame: .zero)
    memojiView.delegate = self
  }

  // MemojiView delegate
 func didUpdateImage(image: UIImage?, type: ImageType) {
    // Do something with the image or check the type of the image and respond accordingly.
 }
}
```

Or use the Closure for processing the image:

```swift        
memojiView.onChange = { image, imageType in
    // Do something on image change   
}
```

###### Create your own

You can subclass MemojiView to add or override subviews. For example, to replace the default UIImageView:
```swift
class CustomMemojiView: MemojiView {
    override func setupUI() {
        let customLabel = UILabel()
        customLabel.text = "Custom Memoji View"
        customLabel.textAlignment = .center
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(customLabel)

        NSLayoutConstraint.activate([
            customLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            customLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
```
### Demo
<div align="center">
<img src="./Example/Supporting Files/Preview/demo.gif" alt="demo.gif" width=40%>
</div>

###### Text input
Like previously stated we can't really control the keyboard and therefore the input of the user.
Simply changing the Keyboard type will lead to different results. Using the default Character Keyboard will also convert them to images.
<div align="center">
<img src="./Example/Supporting Files/Preview/demo_text.gif" alt="demo_text.gif" width=40%>
</div>

Apple does not provide an official way to programmatically force the Emoji Keyboard. However, you can detect when the user changes the keyboard type and react accordingly. This can be particularly useful if you want to take action when the Emoji Keyboard loses focues if the user switches back to another input mode.
The following example demonstrates how to listen for keyboard input mode changes and react only when the input mode changes:

```swift
NotificationCenter.default.addObserver(
    self,
    selector: #selector(inputModeDidChange),
    name: UITextInputMode.currentInputModeDidChangeNotification,
    object: nil
)

@objc func inputModeDidChange(_ notification: Notification) {
    // Attempt to retrieve the new input mode
    guard let currentInputMode = notification.userInfo?["UITextInputFromInputModeKey"] as? UITextInputMode else {
        print("Unable to detect the current input mode.")
        return
    }

    switch currentInputMode.primaryLanguage {
    case "emoji":
        print("Emoji keyboard was active! Handle accordingly.")
    default:
        print("Keyboard type changed to: \(currentInputMode.primaryLanguage ?? "unknown")")
    }
}

```

### SwiftUI Support

Starting from iOS 13, `MemojiView` includes support for SwiftUI through the `MemojiViewRepresentable`. This allows you to integrate MemojiView into your SwiftUI projects.

#### Usage (iOS 13+)

```swift
import SwiftUI
import MemojiView

struct ContentView: View {
    @State private var displayedImage: UIImage?
    @State private var displayedType: MemojiImageType?

    var body: some View {
        VStack(spacing: 20) {
            Text("Memoji Editor").font(.headline)

            MemojiViewRepresentable(
                image: $displayedImage,
                memojiType: $displayedType,
                isEditable: .constant(true),
                maxLetters: 10,
                textColor: .blue
            ) { updatedImage, updatedType in
                print("Updated image: \(updatedImage?.description ?? "nil")")
                print("Updated type: \(updatedType)")
            }
            .frame(height: 200)
            .border(Color.gray, width: 1)
        }
        .padding()
    }
}
```

#### Usage (iOS 12)
For projects targeting iOS 12, the SwiftUI-Support is currently not available. However, you can create a UIKit-compatible wrapper similar to MemojiViewRepresentable. Instead of using bindings, you can rely on closures to handle updates.

### Requirements
- Xcode 11
- iOS 12 or later
- Swift 5 or later


### Installation
##### Swift Package Manager
To integrate `MemojiView` into your project using Swift Package Manager, add the following to your Package.swift file:
```swift
dependencies: [
    .package(url: "https://github.com/emrearmagan/ModalKit.git", from: "0.0.2")
]
```

##### CocoaPods

> **⚠️ Caution**  
> CocoaPods support has been dropped with version 0.0.4 Prior to that, support will not be existing. Using SPM is highly recommended.

You can use CocoaPods to install MemojiView by adding it to your Podfile:

    pod 'MemojiView'

##### Installing MemojiView manually
1. Download MemojiView.zip from the last release and extract its content in your project's folder.
2. From the Xcode project, choose Add Files to ... from the File menu and add the extracted files.

### Contribute
Contributions are highly appreciated! To submit one:
1. Fork
2. Commit changes to a branch in your fork
3. Push your code and make a pull request

</div>
