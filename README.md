# Real time Swift iOS Chat with Firebase Firestore

This is an extremely simple implementation of an iOS Swift Chat app. It leverages <a href="https://github.com/MessageKit/MessageKit">MessageKit</a> and it stores and retrieves data to/from Firebase Firestore. The app design is inspired by Facebook Messenger.

Learn how to build your own iOS chat feature with only a few lines of code. For more details, check out our detailed technical documentation on the official <a href="https://www.iosapptemplates.com/templates/swift-ios-chat-firebase-realtime">iOS Swift Chat app</a> page.


<a href="https://www.iosapptemplates.com/templates/swift-ios-chat-firebase-realtime"><img width="270px" src="https://www.iosapptemplates.com/wp-content/uploads/2018/09/swift-ios-chat-app-threads.png" /></a>
<a href="https://www.iosapptemplates.com/templates/swift-ios-chat-firebase-realtime"><img width="270px" src="https://www.iosapptemplates.com/wp-content/uploads/2018/09/swift-ios-chat-app-room.png" /></a>
<a href="https://www.iosapptemplates.com/templates/swift-ios-chat-firebase-realtime"><img width="270px" src="https://www.iosapptemplates.com/wp-content/uploads/2018/09/swift-ios-chat-app-room-keyboard.png" /></a>

<br/>

## How to run a demo app

1. Download the source code by cloning this repository
2. Install the pods by running
```
pod install
```
3. Open the xcworkspace file with the latest version of Xcode

## How to integrate the chat into your app

1. Download the source code and import the "Core" folder into your Xcode project
2. Make sure you add all the Podfile dependencies into your own Podfile
3. Install the pods

```
pod install
```

4. Use the following code to instantiate a chat view controller

```swift
let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                      secondaryColor: UIColor(hexString: "#f0f0f0"),
                                      inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                      inputTextViewTextColor: .black,
                                      inputPlaceholderTextColor: UIColor(hexString: "#979797"))
let channel = ATCChatChannel(id: "channel_id", name: "Chat Title")
let viewer = ATCUser(firstName: "Florian", lastName: "Marcu")
let chatVC = ATCChatThreadViewController(user: viewer, channel: channel, uiConfig: uiConfig)

// Present the chatVC view controller

```

Coded with love and supported by <a href="https://www.iosapptemplates.com">iOS App Templates</a>.
