# UserProfileKit

The UserProfileKit SDK is a Swift framework that provides a custom WebView for User profile creation which is encapsulating a WKWebView. It supports handling navigation events, custom actions, and messages received from the web view.

## Features

- **CustomWebView Class:** Provides a custom `WebView` behaviour that encapsulates a WKWebView.
- **Navigation Delegate:** Protocol for handling navigation events of the web view.
- **Action Delegate:** Protocol for handling custom actions in the web view.
- **Message Handler:** Protocol for handling messages received from the web view.
- **Configuration:** Customizable WKWebViewConfiguration for advanced configuration options to receive events from the webview.

## Installation

The SDK can be installed via CocoaPods. Add the following line to your Podfile:

    pod 'UserProfileKit'


Then, run pod install from the terminal.

## Integration


Import the framework into your Swift file

     import WebViewSDK

 Create an instance of WebView
   
   
    let webView: WebView!

in override func viewDidLoad() {
   
    
    webView = WebView(frame: view.bounds)


Set up delegates for handling navigation events, custom actions, and messages

  
    webView.navDelegate = self
    webView.actionDelegate = self
    webView.messageDelegate = self

Load a URL

  
      webView.loadURL(url)


Handle custom actions and messages using delegate methods.


## Example

    import UIKit
    import WebViewSDK

    class ViewController: UIViewController, WVNavigationDelegate, WVActionDelegate, WVMessageHandler {

      var webView: WebView!

      override func viewDidLoad() {
          super.viewDidLoad()
          
          webView = WebView(frame: view.bounds)
          webView.navDelegate = self
          webView.actionDelegate = self
          webView.messageDelegate = self
          view.addSubview(webView)
          
          if let url = URL(string: "https://example.com") {
              webView.loadURL(url)
          }
      }
  
      // Implement delegate methods as needed
      // ...
  
  }

## Requirements

- iOS 14.0+
- Swift 4.0+

## License

This SDK is released under the MIT License. See LICENSE for details.
